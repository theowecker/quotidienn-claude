#!/bin/sh
# Tells Claude what is overdue in Quotidienn.
#
#   nudge.sh briefing   at session start: the whole day
#   nudge.sh            on each prompt
#   nudge.sh working    after Claude's tool calls, so a long task still hears
#                       about it; throttled, since tools run constantly
#
# Silent unless the set of nudges has changed since this session last heard
# it, so the same reminder is not repeated. Silent on any failure too: a habit
# tracker being down must never get in the way of work.

token="$CLAUDE_PLUGIN_OPTION_API_TOKEN"
base="${CLAUDE_PLUGIN_OPTION_URL:-https://quotidienn.com}"
[ -n "$token" ] || exit 0

session=$(cat | grep -o '"session_id" *: *"[^"]*"' | sed 's/.*"\([^"]*\)"$/\1/')
state="${TMPDIR:-/tmp}/quotidienn-nudges-${session:-none}"

fetch() {
  curl -fsS --max-time 3 -H "Authorization: Bearer $token" "$base/api/v1/$1"
}

remember() {
  printf '%s' "$1" | grep -o '"digest":"[^"]*"' | head -1 > "$state"
}

if [ "$1" = "briefing" ]; then
  body=$(fetch day) || exit 0
  remember "$body"
  echo "Quotidienn, the user's habit tracker, today (seconds; nudges.items are things that have slipped):"
  echo "$body"
  exit 0
fi

if [ "$1" = "working" ]; then
  now=$(date +%s)
  last=$(cat "$state.checked" 2>/dev/null || echo 0)
  [ $((now - last)) -ge 60 ] || exit 0
  echo "$now" > "$state.checked"
fi

body=$(fetch nudges) || exit 0
[ "$(printf '%s' "$body" | grep -o '"digest":"[^"]*"')" = "$(cat "$state" 2>/dev/null)" ] && exit 0
remember "$body"

case "$body" in
  *'"items":[]'*) exit 0 ;;
esac

message="Quotidienn: something the user meant to do has slipped. Tell them briefly, per the stay-on-track skill: $body"

if [ "$1" = "working" ]; then
  # After a tool call, plain stdout only reaches the transcript; Claude sees
  # it only as additionalContext. The body is single-line JSON, so escaping
  # backslashes and quotes is enough to embed it.
  escaped=$(printf '%s' "$message" | sed -e 's/\\/\\\\/g' -e 's/"/\\"/g')
  printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"%s"}}\n' "$escaped"
else
  echo "$message"
fi

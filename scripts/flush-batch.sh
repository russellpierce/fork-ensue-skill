#!/bin/bash
# Flush batched messages to Ensue

SESSION_ID="${1:-unknown}"
BATCH_FILE="/tmp/ensue-batch-${SESSION_ID}.jsonl"

[ -z "$ENSUE_API_KEY" ] && exit 0
[ ! -f "$BATCH_FILE" ] && exit 0

# Get current batch number
BATCH_NUM=$(cat /tmp/ensue-batchnum-${SESSION_ID} 2>/dev/null || echo "0")
BATCH_NUM=$((BATCH_NUM + 1))
echo "$BATCH_NUM" > /tmp/ensue-batchnum-${SESSION_ID}

# Build items array from batch file
ITEMS=$(cat "$BATCH_FILE" | jq -s --arg sid "$SESSION_ID" --arg bn "$BATCH_NUM" '
  to_entries | map({
    key_name: "sessions/\($sid)/msgs/\($bn)-\(.key)",
    description: .value.msg[0:200],
    value: .value.msg,
    embed: true
  })
')

# Create memories
curl -s -X POST https://api.ensue-network.ai/ \
  -H "Authorization: Bearer $ENSUE_API_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"jsonrpc\":\"2.0\",\"method\":\"tools/call\",\"params\":{\"name\":\"create_memory\",\"arguments\":{\"items\":$ITEMS}},\"id\":1}" > /dev/null &

# Clear batch file
> "$BATCH_FILE"

exit 0

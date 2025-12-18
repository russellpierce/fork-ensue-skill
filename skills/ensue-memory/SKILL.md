---
name: ensue-memory
description: Persistent memory layer for AI agents via Ensue Memory Network API. Use when users ask to remember, recall, search memories, manage permissions, subscribe to updates, or ask what they can do with Ensue. Triggers on "remember this", "recall", "search memories", "update memory", "list keys", "share", "subscribe to", "permissions", "what can I do with ensue", or any persistent storage request.
---

# Ensue Memory Network

Dynamic memory service accessed via curl.

## IMPORTANT: Do NOT use native MCP tools

**NEVER use these for ANY Ensue query (including capability questions):**
- `listMcpResources`
- `listMcpTools`
- `mcp__*` tools
- Any native MCP tool calls

**ONLY use curl** as described below. This ensures consistent behavior and dynamic schema discovery.

## Security: API Key Handling

**CRITICAL: Never expose the API key in the session.**

- **NEVER** use `echo $ENSUE_API_KEY` or any command that prints the key
- **NEVER** accept the API key inline from the user in the conversation
- **NEVER** interpolate the key into commands in a way that could be logged
- **ALWAYS** require the key to be set as an environment variable before proceeding

## Execution Order (MUST FOLLOW)

**Step 1: Verify API key is set**

Check if `ENSUE_API_KEY` is set WITHOUT revealing its value:

```bash
[ -z "$ENSUE_API_KEY" ] && echo "ENSUE_API_KEY is not set" || echo "ENSUE_API_KEY is set"
```

If not set, tell the user to set `ENSUE_API_KEY` (get one at https://www.ensue-network.ai/dashboard). Do not proceed until confirmed.

**Step 2: List available tools (REQUIRED before any tool call)**

```bash
curl -s -X POST https://api.ensue-network.ai/ \
  -H "Authorization: Bearer $ENSUE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/list","id":1}'
```

This returns tool names, descriptions, and input schemas. **Never skip this step.**

**Step 3: Call the appropriate tool**

```bash
curl -s -X POST https://api.ensue-network.ai/ \
  -H "Authorization: Bearer $ENSUE_API_KEY" \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc":"2.0","method":"tools/call","params":{"name":"<tool_name>","arguments":{<args>}},"id":1}'
```

Use the schema from Step 2 to construct correct arguments.

## Batch Operations

For 3+ similar operations, use a bash loop instead of individual commands. Keep it simple.

## Context Optimization

**CRITICAL: Minimize context window usage.** Users may have 100k+ keys. Never dump large lists into the conversation.

### When users ask "what's on Ensue" / "show my memories" / "list keys"

**Do NOT** call `list_keys` or guess a search query. Be interactive:

1. **Ask the user first**: "What would you like to find?"
2. **Wait for their response** before calling any search tool
3. **Use `discover_memories`** with their query and **limit: 3**
4. **Offer to show more** after displaying results

**Never invent queries. You are a guide, not an assumer.**

### Prefer semantic search over listing

| Instead of... | Do this... |
|---------------|------------|
| `list_keys` | `discover_memories` with limit 3 |
| Showing all keys | Ask what they need, then search |
| Paginating through everything | Search for what's relevant, offer to show more |

## Intent Mapping

| User says | Action |
|-----------|--------|
| "what can I do", "capabilities", "help" | Steps 1-2 only (summarize tools/list response) |
| "remember...", "save...", "store..." | create_memory |
| "what was...", "recall...", "get..." | get_memory (exact key) or discover_memories with limit 3 |
| "search for...", "find..." | discover_memories with limit 3 (offer to show more) |
| "update...", "change..." | update_memory |
| "delete...", "remove..." | delete_memory ⚠️ |
| "list keys", "show memories", "what's on ensue" | **Ask user what to search for first**, then discover_memories with limit 3 |
| "share with...", "give access..." | share |
| "revoke access...", "remove user..." | revoke_share ⚠️ |
| "who can access...", "permissions" | list_permissions |
| "notify when...", "subscribe..." | subscribe_to_memory |

## ⚠️ Destructive Operations

For `delete_memory` and `revoke_share`: show what will be affected, warn it's permanent, and get user confirmation before executing.

## Memory Quality

Memories serve as agentic context. They should be:
- **Precise** - specific facts, not vague summaries
- **Granular** - one concept per memory, not dumps
- **Pointed** - actionable context that aids reasoning
- **Non-limiting** - inform the agent, don't constrain it

Bad: "User likes clean code and good practices"
Good: "User prefers early returns over nested conditionals"

## Key Naming

Use hierarchical paths: `category/subcategory/name`

Examples: `preferences/theme`, `project/api-keys`, `notes/meeting-2024-01`

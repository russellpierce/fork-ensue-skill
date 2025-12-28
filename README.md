# Ensue Memory Network

Persistent memory for AI agents with semantic search.


## Install (Claude Code)

```
/plugin marketplace add https://github.com/mutable-state-inc/ensue-skill
```

```
/plugin install ensue-memory
```

Restart Claude Code. The skill will guide you through setup.

## Configuration

| Variable | Description |
|----------|-------------|
| `ENSUE_API_KEY` | Required. Get one at [dashboard](https://www.ensue-network.ai/dashboard) |
| `ENSUE_READONLY` | Set to `true` to disable auto-logging (session tracking, tool capture). Manual `remember`/`recall` still works. |

```bash
# Disable auto-logging for a session
ENSUE_READONLY=true claude

# Or add to ~/.zshrc for permanent read-only mode
export ENSUE_READONLY=true
```

## Try it

```
"remember my preferred stack is React + Postgres"
```

## Links

[Docs](https://www.ensue-network.ai/docs) · [Dashboard](https://www.ensue-network.ai/dashboard) · [Homepage](https://ensue.dev) · API: `https://api.ensue-network.ai`

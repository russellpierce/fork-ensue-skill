# Ensue Memory Network

**Get smarter alongside your AI.**

Your intelligence shouldn't reset every conversation. Ensue is a persistent knowledge tree that grows with you - what you learn today enriches tomorrow's reasoning.

## The Idea

Every conversation with an LLM starts from zero. You explain context, re-establish preferences, repeat decisions you've already made. Your knowledge doesn't compound.

Ensue changes that:

- **Your knowledge persists** - Build a tree of intelligence that spans conversations
- **Context carries forward** - Prior research, decisions, and insights inform new work
- **You get smarter together** - The LLM learns your thinking patterns, not just facts

Think of it as extended memory. When you ask about GPU inference, the LLM checks what you already know. When you make an architecture decision, it connects to past decisions in similar domains. Your accumulated knowledge becomes part of every conversation.

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
"what do I know about caching strategies?"
"check my research/distributed-systems/ notes"
```

## Links

[Docs](https://www.ensue-network.ai/docs) · [Dashboard](https://www.ensue-network.ai/dashboard) · [Homepage](https://ensue.dev) · API: `https://api.ensue-network.ai`

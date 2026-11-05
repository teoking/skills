# Productivity

General workflow tools, not code-specific.

## User-invoked

Reachable only when you type them (Claude Code: `disable-model-invocation: true`; Codex: `policy.allow_implicit_invocation: false` in `agents/openai.yaml`).

- **[grill-me](./grill-me/SKILL.md)**：无状态需求访谈：围绕计划或设计持续提问，直到设计树的所有分支都明确。
- **[handoff](./handoff/SKILL.md)**：上下文交接：综合当前讨论，将脱敏后的交接文档写入系统临时目录，供新 agent 接续工作。
- **[teach](./teach/SKILL.md)**: Teach the user a new skill or concept over multiple sessions, using the current directory as a stateful teaching workspace.
- **[to-questionnaire](./to-questionnaire/SKILL.md)**: Turn a decision you can't answer alone into a Markdown questionnaire for the one person who can (filled in async, or together over a meeting).
- **[wait-what](./wait-what/SKILL.md)**: Fire this the moment a message doesn't land. The agent re-pitches it with the context you're missing, in plain English, using your `GLOSSARY.md` vocabulary.

## Model-invoked

Model- or user-reachable (rich trigger phrasing so the model can reach for them).

- **[grilling](./grilling/SKILL.md)**: 需求澄清：按设计树逐轮提问，查明事实、等待用户决策，直到双方确认理解一致。
- **[writing-for-agents](./writing-for-agents/SKILL.md)**: 技能与指令编写：面向 agent 编写技能、AGENTS.md / CLAUDE.md 与按需读取的参考文档。

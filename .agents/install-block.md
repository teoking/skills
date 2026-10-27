# The canonical install block

One install story, one wording. `README.md`, `.changeset/*`, and every page under `docs/` must say **this** and nothing else. Change it here first, then propagate.

## Fork installation source

All installation routes use the `codingrock` branch of `git@github.com:teoking/skills.git`. The `main` branch mirrors upstream and does not contain the Chinese customizations. Configure GitHub SSH access first. These commands install pushed commits, not uncommitted local changes.

Claude Code, Codex and Copilot use this repository's `teoking` marketplace. The plugin retains its name `mattpocock-skills`; install it as `mattpocock-skills@teoking`. The official marketplace and `@mattpocock` remain upstream sources.

Choose one source per agent. Remove an existing upstream copy through the host's plugin manager before enabling the fork, so identical skill names do not appear twice. Automatic updates depend on host settings; a new commit alone does not guarantee an installed plugin update. The plugin version remains synced with `package.json` through `npm run version`.

## Claude Code

<canonical-block name="claude-code">

```bash
claude plugin marketplace add "git@github.com:teoking/skills.git#codingrock"
claude plugin install mattpocock-skills@teoking
```

使用本 fork 的 `teoking` marketplace；更新方式以宿主的插件设置为准。

</canonical-block>

## Codex

<canonical-block name="codex">

```bash
codex plugin marketplace add git@github.com:teoking/skills.git --ref codingrock
codex plugin add mattpocock-skills@teoking
```

使用本 fork 的 `teoking` marketplace；更新方式以宿主的插件设置为准。

</canonical-block>

## GitHub Copilot (CLI and VS Code)

Use the fork marketplace. The SSH installation path has not been exercised against a live remote in this workspace.

<canonical-block name="copilot">

```bash
git clone --branch codingrock --single-branch git@github.com:teoking/skills.git skills-codingrock
copilot plugin marketplace add ./skills-codingrock
copilot plugin install mattpocock-skills@teoking
```

保留 `skills-codingrock` 检出目录。更新时先运行 `git -C skills-codingrock pull --ff-only`，再通过宿主插件管理器更新插件；本地来源不会自行拉取远端分支。

In VS Code, run **Chat: Install Plugin From Source** and enter `git@github.com:teoking/skills.git#codingrock`.

</canonical-block>

## Gemini CLI

Clone the required branch first, then install the two promoted bucket directories. This avoids relying on a host-specific Git ref syntax.

<canonical-block name="gemini">

```bash
git clone --branch codingrock --single-branch git@github.com:teoking/skills.git skills-codingrock
gemini skills install ./skills-codingrock/skills/engineering
gemini skills install ./skills-codingrock/skills/productivity
```

更新时先运行 `git -C skills-codingrock pull --ff-only`，再重复两条 `gemini skills install` 命令。已有检出目录时跳过 clone，并确认其分支为 `codingrock`。

</canonical-block>

## Every other agent, or editable files (skills.sh)

`-a` preselects the agent. Each agent in the comment was run on 2026-10-07. Prefer skills.sh to an agent's own repo installer, such as `amp skill add` or `pi install git:…`, because those also pull in `misc/` and `in-progress/`. Re-run the branch-qualified `add` command for updates; do not substitute an unqualified repository URL.

<canonical-block name="other-agents">

```bash
npx skills@latest add "git@github.com:teoking/skills.git#codingrock" -a <agent>  # cursor, opencode, devin, windsurf, amp, pi; omit -a to choose
```

When the installer asks which skills to take, include `setup-matt-pocock-skills`. To update, re-run the same `add` command with `#codingrock`, preserving the branch selection and picking up new skills.

</canonical-block>

Use the single-skill form wherever one skill is named on its own. `docs/` pages don't use this block, because ai-hero renders the install widget above the page body. See [writing-docs.md](./writing-docs.md).

<canonical-block name="skills-sh-one-skill">

```bash
npx skills@latest add "git@github.com:teoking/skills.git#codingrock" --skill=<name>
```

```bash
npx skills@latest add "git@github.com:teoking/skills.git#codingrock" --skill=<name>
```

</canonical-block>

`skills@latest` is the pinned spelling everywhere.

## The two routes are exclusive

The plugin is a managed, read-only bundle you subscribe to. skills.sh writes files you own and edit. Installing both leaves the user with every skill twice: always say "pick one".

## Branch syntax verification

Codex's local `plugin marketplace add --help` documents `--ref`. The installed skills.sh parser supports Git URL fragments. Claude Code documents `#<ref>` in [Host a marketplace](https://code.claude.com/docs/en/plugins/host-marketplace), and VS Code documents it in [Agent plugins](https://code.visualstudio.com/docs/agent-customization/agent-plugins). Copilot CLI and Gemini use a Git checkout pinned to the branch, then their local-directory install route. Live SSH installs have not been run here.

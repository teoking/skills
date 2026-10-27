#!/usr/bin/env bash
# 人在环路（HITL）的复现循环。
# 复制本文件，修改下方步骤，然后运行。
# agent 运行脚本，用户在终端中按提示操作。
#
# 用法：
#   bash hitl-loop.template.sh
#
# 两个辅助函数：
#   step "<instruction>"          → 显示操作说明，等待回车
#   capture VAR "<question>"      → 显示问题，将回答读入 VAR
#
# 最后以 KEY=VALUE 输出采集值，供 agent 解析。
#
# `capture` 会把采集值输出到终端供 agent 读取，
# 因此只采集观察结果；登录应由用户在 `step` 中完成。

set -euo pipefail

step() {
  printf '\n>>> %s\n' "$1"
  read -r -p "    [完成后按回车] " _
}

capture() {
  local var="$1" question="$2" answer
  printf '\n>>> %s\n' "$question"
  read -r -p "    > " answer
  printf -v "$var" '%s' "$answer"
}

# --- 在下方修改 ---------------------------------------------------------

step "打开 http://localhost:3000 并登录。"

capture ERRORED "点击 'Export' 按钮，是否报错？(y/n)"

capture ERROR_MSG "粘贴已脱敏的错误信息（没有则填 'none'）："

# --- 在上方修改 ---------------------------------------------------------

printf '\n--- 已采集 ---\n'
printf 'ERRORED=%s\n' "$ERRORED"
printf 'ERROR_MSG=%s\n' "$ERROR_MSG"

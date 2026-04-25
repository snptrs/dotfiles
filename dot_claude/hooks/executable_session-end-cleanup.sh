#!/usr/bin/env bash
# SessionEnd hook: kills any background server started by the sketch skill.
# Reads the PID from <project>/.claude/.runtime/sketch-server.pid if present.
set -u

project_dir="${CLAUDE_PROJECT_DIR:-$(pwd)}"
pid_file="${project_dir}/.claude/.runtime/sketch-server.pid"

[ -f "$pid_file" ] || exit 0

pid=$(cat "$pid_file" 2>/dev/null)
if [ -n "$pid" ] && kill -0 "$pid" 2>/dev/null; then
  kill "$pid" 2>/dev/null || true
  sleep 0.5
  kill -0 "$pid" 2>/dev/null && kill -9 "$pid" 2>/dev/null || true
fi

rm -f "$pid_file"
exit 0

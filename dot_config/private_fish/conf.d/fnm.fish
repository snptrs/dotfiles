set -gx FNM_COREPACK_ENABLED true
status is-interactive && /opt/homebrew/bin/fnm env --use-on-cd | source

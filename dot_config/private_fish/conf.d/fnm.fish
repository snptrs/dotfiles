set -gx FNM_COREPACK_ENABLED true
status is-interactive && fnm env --use-on-cd | source

#!/usr/bin/env bash

CURR_DIR=$(dirname $(readlink -f $0))
. ${CURR_DIR}/eee-common.sh

INITIAL_QUERY="$1"

FZF_DEFAULT_COMMAND='fd --type f --type l --hidden --exclude .git --exclude target | devicon-lookup -i -c' \
	fzf \
    --query "$INITIAL_QUERY" \
	--border \
    --layout reverse \
	--exact \
	--ansi \
	--cycle \
	--color "border:#A15ABD" \
	--header-first \
	--header "CWD:$(pwd)
[Alt-C]:Change Dir(TODO); [RET]: select;
TOOD: extended help information
${HEADER_KEYBIND_HELP}
" \
	--preview 'filename={}; bat -n --color=always ${filename:2}' \
	--preview-window 'right,60%,border-bottom,wrap,+{2}+3/3,~3' \
	--bind "${FZF_BINDS}" \
	--bind 'ctrl-/:change-preview-window(down|hidden|)' \
	--bind 'ctrl-d:change-prompt(Directories> )+reload(find * -type d)' \
    --bind 'ctrl-f:page-down,ctrl-b:page-up' \
	--bind 'ctrl-u:change-prompt(Directories> )+reload(find $(dirname $(pwd)) -type d)' |
	xargs -0 -I{} bash -c 'filename_with_icon="{}"; filename="${filename_with_icon:2}"; echo "${filename}"' \
		| xargs -0 -I{} realpath {}

# --bind 'ctrl-f:change-prompt(Files> )+reload(find * -type f)' \

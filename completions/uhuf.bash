#!/usr/bin/env bash

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

# Check config file (fails silently if not found)
if [ -f /etc/uhuf.conf ]; then
    CONFIG_FILE=/etc/uhuf.conf
elif [ -f "$SCRIPT_DIR/../etc/uhuf.conf" ]; then
    CONFIG_FILE="$SCRIPT_DIR/../etc/uhuf.conf"
fi

unset SCRIPT_DIR

# Parse config file
if [ -f "$CONFIG_FILE" ]; then
    source read_ini.sh
    read_ini "$CONFIG_FILE"
fi

# Use UHUF_* variables
UHUF_GITLAB_URL="$INI__uhuf__gitlab_url"
UHUF_PROJECT_ID="$INI__uhuf__project_id"
UHUF_PRIVATE_TOKEN="$INI__uhuf__private_token"

UHUF_TREE_URL="$UHUF_GITLAB_URL/api/v3/projects/$UHUF_PROJECT_ID/repository/tree/?path="

_curl_tree() {
    [ -n "$1" ] && local path="$1/"
    curl -s -H "PRIVATE-TOKEN: $UHUF_PRIVATE_TOKEN" "$UHUF_TREE_URL${1}" | \
        JSON.sh -l | egrep '\[[0-9]+,"name"\]|\[[0-9]+,"type"\]' | \
        gawk '{ print $2 }' | tr -d '"' | xargs -L 2 | \
        gawk -v path=$path \
        '$2 == "tree" { print path$1"/" } $2 == "blob" { print path$1 }'
}

_contains_slash() {
    echo "$1" | grep '/' > /dev/null
}

_uhuf_comp() {
    COMPREPLY=();
    local word="${COMP_WORDS[COMP_CWORD]}";
    local path=
    if _contains_slash "$word"; then
        local path="${word%/*}"
    fi
    COMPREPLY=($(compgen -W "$(_curl_tree $path)" -- "$word"));
}

if [ -n "$CONFIG_FILE" ]; then
    complete -o nospace -F _uhuf_comp uhuf
fi

unset CONFIG_FILE

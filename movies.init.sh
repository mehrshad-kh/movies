#!/bin/zsh

# Remove if not necessary.
# set -P
set -euo pipefail

zmodload zsh/zutil
zparseopts {n,-name}:=name_value {u,-url}:=url_value || exit 1

if [[ $# -eq 0 ]] || [[ ${#name_value[@]} -eq 0 ]] || [[ ${#url_value[@]} -eq 0 ]]; then
    echo "usage: init -n name -u url"
    exit 1
fi

if [[ -f .info ]]; then
    echo "fatal: movies repository already exists in $PWD/" >&2
    exit 1
fi

echo "name = ${name_value[2]}" >> .info
echo "url = ${url_value[2]}" >> .info
echo "Initialized .info in $(pwd -P)/"

exit 0

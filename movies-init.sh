#!/bin/zsh

# Remove if not necessary.
# set -P
set -euo pipefail

zmodload zsh/zutil
zparseopts {n,-name}:=name_value {u,-url}:=url_value || exit 1

info=".movies/info"

if [[ $# -eq 0 ]] || [[ ${#name_value[@]} -eq 0 ]] || [[ ${#url_value[@]} -eq 0 ]]; then
    echo "movies init [-n | --name show-name] [-u | --url url]"
    exit 1
fi

if [[ -d .movies ]]; then
    echo "fatal: movies repository already exists in $PWD/" >&2
    exit 1
fi

mkdir .movies
echo "name = ${name_value[2]}" >> ${info}
echo "url = ${url_value[2]}" >> ${info}
echo "Initialized Movies repository in $(pwd -P)/.movies/"

exit 0

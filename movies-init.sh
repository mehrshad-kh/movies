#!/bin/zsh

set -euo pipefail

zmodload zsh/zutil
# name and value are required arguments.
zparseopts {n,-name}:=name_argument {u,-url}:=url_argument || exit 1

info=".movies/info"

if [[ $# -eq 0 ]] || [[ ${#name_argument[@]} -eq 0 ]] || [[ ${#url_argument[@]} -eq 0 ]]; then
    echo "movies init [-n | --name <name>] [-u | --url <url>]"
    exit 1
fi

if [[ -d .movies ]]; then
    echo "fatal: movies repository already exists in $PWD/" >&2
    exit 1
fi

mkdir .movies
echo "name = ${name_argument[2]}" >> ${info}
echo "url = ${url_argument[2]}" >> ${info}
echo "Initialized Movies repository in $(pwd -P)/.movies/"

exit 0

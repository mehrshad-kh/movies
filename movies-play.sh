#!/bin/zsh

set -euo pipefail

zmodload zsh/zutil
zparseopts {s,-seek}:=seek_value || exit 1

latest=".movies/latest"

if [[ ! -h ${latest} ]]; then
    echo "error: ${latest}: no such file" >&2
    echo "Have you run \`movies link\'?" >&2
    exit 1
fi

if [[ $# -eq 0 ]]; then
    # -sn   disable subtitles
    # -ss pos   seek pos. Check format man page.
    ffplay ${latest} -fs -autoexit
else
    if [[ ${#seek_value[@]} -eq 0 ]]; then
        >&2 echo "usage: movies play [ -s | --seek ] seconds"
        exit 1
    fi

    ffplay -fs -autoexit -loglevel warning -ss ${seek_value[2]} ${latest} 
fi

exit 0

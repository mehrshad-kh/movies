#!/bin/zsh

set -euo pipefail

zmodload zsh/zutil
zparseopts {s,-seek}:=seek_value || exit 1

latest=".movies/latest"

# -sn: Disable subtitles.
ffplay_options='-fs -autoexit -loglevel warning'

if [[ ! -h ${latest} ]]; then
    echo "error: ${latest}: no such file" >&2
    echo "Have you run \`movies link\'?" >&2
    exit 1
fi

if [[ $# -eq 0 ]]; then
    eval "ffplay ${latest} ${ffplay_options}"
elif [[ ${#seek_value[@]} -eq 0 ]]; then
    >&2 echo "usage: movies play [ -s | --seek ] <seconds>"
    exit 1
else
    # -ss pos: Seek pos. Check format man page.
    eval "ffplay ${latest} ${ffplay_options} -ss ${seek_value[2]}"
fi

exit 0

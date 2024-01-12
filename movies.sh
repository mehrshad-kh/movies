#!/bin/zsh

# -e    exit the script in case any command fails
# -u    exit in case of previously undefined variables being used
# -o pipefail   exit if any portion of a pipe fails
set -euo pipefail

# This is where actual scripts are located.
movies_dir=${$(readlink -f ${0})%/*}

if [[ $# -eq 0 ]]; then
    echo "usage: movies continue | download | init | link | play" >&2
    exit 1
fi

subcommand_found=0
subcommands=(continue download link play)
if [[ $1 = "init" ]]; then
    subcommand_found=1
    shift; ${movies_dir}/movies.init.sh "$@"
else
    for subcommand in ${subcommands[@]}; do
        if [[ $1 == ${subcommand} ]]; then
            subcommand_found=1
            if [[ ! -d .movies ]]; then
                >&2 echo "fatal: not a movies repository: .movies"
                exit 1
            fi

            shift; ${movies_dir}/movies.${subcommand}.sh "$@"
            break
        fi
    done
fi

if [[ ${subcommand_found} == 0 ]]; then
    echo "usage: movies continue | download | init | link | play" >&2
    exit 1
fi

exit 0

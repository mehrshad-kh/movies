#!/bin/zsh

# -e    exit the script in case any command fails
# -u    exit in case of previously undefined variables being used
# -o pipefail   exit if any portion of a pipe fails
set -euo pipefail

function printHelp
{
    echo "usage: movies continue | download | init | link | play"
    echo "Consult the man pages for further details."
    echo
    echo "Summary:"
    echo "\tBegin with \`movies init --name <name> --url <url>'"
    echo "\tThen, download the first episode with \`movies download --next'"
    echo "\tRun \`movies link --first'"
    echo "\tPlay with \`movies play'"
    echo
    echo "\tDownload subsequent episodes with \`movies download --next'"
    echo "\tMake sure to run \`movies link --next' after each download."
}

# This is where actual scripts are located.
movies_dir=${$(readlink -f ${0})%/*}

if [[ $# -eq 0 ]]; then
    printHelp
    exit 1
fi

subcommand_found=0
subcommands=(continue download link play)
if [[ $1 = "init" ]]; then
    subcommand_found=1
    shift; ${movies_dir}/movies-init.sh "$@"
else
    for subcommand in ${subcommands[@]}; do
        if [[ $1 == ${subcommand} ]]; then
            subcommand_found=1
            if [[ ! -d .movies ]]; then
                >&2 echo "fatal: not a movies repository: .movies"
                exit 1
            fi

            shift; ${movies_dir}/movies-${subcommand}.sh "$@"
            break
        fi
    done
fi

if [[ ${subcommand_found} == 0 ]]; then
    printHelp
    exit 1
fi

exit 0

#!/bin/zsh

set -euo pipefail

latest=".movies/latest"
info=".movies/info"

series_name="$(cat ${info} \
    | grep -E "^name =" \
    | cut -d "=" -f 2 \
    | xargs)"
episode_name=$(ls ${series_name}* \
    | sort \
    | tail -n 1 \
    | rev \
    | cut -d "/" -f 1 \
    | rev)

case $# in
    0)
        latest_episode_name=${episode_name}
        ;;
    1)
        if [[ $1 =~ [0-9]+ ]]; then
            some_episode_name=${episode_name}
            some_episode_number=$(echo ${some_episode_name} \
                | grep -oE "E\d{2}" \
                | cut -c 2-3)
            latest_episode_name=$(echo ${some_episode_name} \
                | sed -E "s/$(printf "%c%02d" E ${some_episode_number})/$(printf "%c%02d" E $1)/")
            if [[ ! -f ${latest_episode_name} ]]; then 
                >&2 echo "error: specified episode does not exist"; 
                exit 1; 
            fi
        elif [[ $1 = "-f" || $1 = "--first" ]]; then
            latest_episode_name=$(ls ${series_name}* | sort | head -n 1)
        else
            if [[ $1 = "-n" || $1 = "--next" ]]; then
                offset=1
            elif [[ $1 = "-p" || $1 = "--prev" ]]; then
                offset=-1
            else
                echo "usage: link [ -f | -n | -p ]"
                exit 1
            fi

            # The parameter expansion is used to 
            # retrieve just the filename, without path.
            current_latest_episode_name=${$(readlink ${latest})##*/}
            current_latest_episode_number=$(echo ${current_latest_episode_name} \
                | grep -oE "E[0-9]{2}" \
                | cut -c 2-3)
            latest_episode_number=$((current_latest_episode_number + offset))
            latest_episode_name=$(echo ${current_latest_episode_name} \
                | sed -E "s/$(printf "%c%02d" E ${current_latest_episode_number})/$(printf "%c%02d" E ${latest_episode_number})/")
            if [[ ! -f ${latest_episode_name} ]]; then 
                >&2 echo "error: $([[ offset -eq 1 ]] && echo next || echo previous) episode does not exist"; 
                exit 1; 
            fi
        fi
        ;;
    *)
        echo "usage"
        exit 1
        ;;
esac

ln -fs ../${latest_episode_name} ${latest}

exit 0

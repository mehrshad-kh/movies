#!/bin/zsh

set -euo pipefail

if ! [ -h latest ]; then
    new_episode_link="$(cat .info | grep -E "^url" | cut -d "=" -f 2 | xargs)"
else
    last_episode_filename=$(readlink latest)
    last_episode_number=$(echo ${last_episode_filename} | cut -d "." -f 5 | cut -c 5-6)
    # Arithmetic expansion
    new_episode_number=$(($last_episode_number + 1))

    last_formatted_episode_number=$(printf "%02d" ${last_episode_number})
    new_formatted_episode_number=$(printf "%02d" ${new_episode_number})

    new_episode_filename=$(echo ${last_episode_filename} | sed "s/E${last_formatted_episode_number}/E${new_formatted_episode_number}/")

    first_episode_link="$(cat .info | grep "^url" | cut -d "=" -f 2)"
    new_episode_link="$(echo ${first_episode_link} | rev | cut -d "/" -f 2- | rev)/${new_episode_filename}"
fi

curl -L -g -O --retry-all-errors --retry-max-time 120 ${new_episode_link}

#!/bin/zsh

set -euo pipefail

if ! [[ -h latest ]]; then
    new_episode_link="$(cat .info | grep -E "^url" | cut -d "=" -f 2 | xargs)"
else
    last_episode_filename=$(readlink latest)
    # Problematic
    last_episode_number=$(echo ${last_episode_filename} | grep -oE "E\d{2}" | cut -c 2-3)
    # Arithmetic expansion
    new_episode_number=$(($last_episode_number + 1))

    last_formatted_episode_number=$(printf "%02d" ${last_episode_number})
    new_formatted_episode_number=$(printf "%02d" ${new_episode_number})

    new_episode_filename=$(echo ${last_episode_filename} | sed "s/E${last_formatted_episode_number}/E${new_formatted_episode_number}/")

    first_episode_link="$(cat .info | grep "^url" | cut -d "=" -f 2 | xargs)"
    new_episode_link="$(echo ${first_episode_link} | rev | cut -d "/" -f 2- | rev)/${new_episode_filename}"
fi

# -L, --location: Follow the request onto the last location.
# -O, --remote-name: Write output to a local file named like the remote file we get.
# -f, --fail: Fail silently.
curl -C - -L -O -f --retry-all-errors --retry-max-time 30 ${new_episode_link}

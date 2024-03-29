#!/bin/zsh

set -euo pipefail

info=".movies/info"

last_episode_filename=$(readlink latest)

first_episode_link="$(cat ${info} | grep "^url =" | cut -d "=" -f 2 | xargs)"
new_episode_link="$(echo ${first_episode_link} | rev | cut -d "/" -f 2- | rev)/${last_episode_filename}"

curl -L -O -C - -f --retry-all-errors --retry-max-time 120 ${new_episode_link}

exit 0

#!/bin/zsh

set -euo pipefail
zmodload zsh/zutil
zparesopts {n,-next} {c,--current}

latest=".movies/latest"
info=".movies/info"

if [[ $# -eq 1 ]] && [[ $1 =~ "(-n|--next)" ]]; then
else
  >&2 echo "usage: movies download [-n, --next]"
  exit 1
fi

if ! [[ -h ${latest} ]]; then
  new_episode_link="$(cat ${info} \
    | grep -E "^url" \
    | cut -d "=" -f 2 \
    | xargs)"

  new_episode_filename="$(echo ${new_episode_link} \
    | rev \
    | cut -d "/" -f 1 \
    | rev)"
else
  last_episode_filename=$(readlink ${latest})

  last_episode_number=$(echo ${last_episode_filename} \
    | grep -oE "E\d{2}" \
    | cut -c 2-3)

  new_episode_number=$((${last_episode_number} + 1))
  new_formatted_episode_number=$(printf "%02d" ${new_episode_number})

  first_episode_link="$(cat ${info} \
    | grep -E "^url =" \
    | cut -d "=" -f 2 \
    | xargs)"
  first_episode_filename="$(echo ${first_episode_link} \
    | rev \
    | cut -d "/" -f 1 \
    | rev)"

  new_episode_filename="$(echo ${first_episode_filename} \
    | sed -E "s/E[0-9]{2}/E${new_formatted_episode_number}/")"
  new_episode_link="$(echo ${first_episode_link} \
    | rev \
    | cut -d "/" -f 2- \
    | rev)/${new_episode_filename}"
fi

if [[ -f ${new_episode_filename} ]]; then
>&2 echo "error: next episode already exists"
  exit 1
fi

echo "Download begins for: ${new_episode_filename}"
curl -C - -L -O -f --retry-all-errors --retry-max-time 30 ${new_episode_link}

movies link --next

exit 0

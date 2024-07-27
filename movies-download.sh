#!/bin/zsh

set -euo pipefail

zmodload zsh/zutil
# Either flag must be used, but not both.
# Currently, both options may be used as well, which is not the intended usage.
zparseopts {n,-next}=next_flag {c,-current}=current_flag || exit 1

latest=".movies/latest"
info=".movies/info"
usage="usage: movies download [-n | --next], [-c | --current]"

new_episode_filename=""
new_episode_link=""

function download_current
{
  last_episode_filename="$(readlink ${latest})"

  # Remove the initial '../'.
  last_episode_filename="$(echo ${last_episode_filename} | sed -E "s/^\.\.\///")"

  first_episode_link="$(cat ${info} \
    | grep "^url =" \
    | cut -d "=" -f 2 \
    | xargs)"
  new_episode_link="$(echo ${first_episode_link} \
    | rev \
    | cut -d "/" -f 2- \
    | rev)/${last_episode_filename}"

  new_episode_filename="${last_episode_filename}"
}

function download_next
{
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
    last_episode_filename="$(readlink ${latest})"

    last_episode_number=$(echo ${last_episode_filename} \
      | grep -oE "E\d{2}" \
      | cut -c 2-3)

    new_episode_number=$((${last_episode_number} + 1))
    new_formatted_episode_number="$(printf "%02d" ${new_episode_number})"

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

  if [[ -f "${new_episode_filename}" ]]; then
  >&2 echo "error: next episode already exists"
    exit 1
  fi
}

if [[ "${#next_flag}" == 1 ]]; then
  download_next
  verb="begins"
elif [[ "${#current_flag}" == 1 ]]; then
  download_current
  verb="continues"
fi

echo "Download ${verb} for: ${new_episode_filename}"
curl -C - -L -O -f --retry-all-errors --retry-max-time 30 "${new_episode_link}"

movies link --next

exit 0

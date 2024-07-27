#!/bin/zsh

set -euo pipefail

info=".movies/info"
latest=".movies/latest"

curl -L -O -C - -f --retry-all-errors --retry-max-time 120 ${new_episode_link}

exit 0

#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for monerod"

  set -- monerod "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "monerod" ]; then
  mkdir -p "$DATA_PATH"
  chmod 700 "$DATA_PATH"
  chown -R monero "$DATA_PATH"

  echo "$0: setting data directory to $DATA_PATH"

  set -- "$@" --data-dir="$DATA_PATH" --non-interactive
fi

if [ "$1" = "monerod" ]; then
  echo
  exec gosu monero "$@"
fi

echo
exec "$@"


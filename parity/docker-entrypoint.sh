#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for parity"

  set -- parity "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "parity" ]; then
  DATA_DIR=${DATA_DIR:-/home/daemon/.daemon}
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R daemon "$DATA_DIR"

  echo "$0: setting data directory to $DATA_DIR"

  set -- "$@" --config=/config.toml --base-path="$DATA_DIR"
fi

if [ "$1" = "parity" ]; then
  echo
  exec gosu daemon "$@"
fi

echo
exec "$@"


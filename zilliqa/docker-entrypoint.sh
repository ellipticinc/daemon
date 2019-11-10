#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for zilliqa"

  set -- zilliqa "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "zilliqa" ]; then
  DATA_DIR=${DATA_DIR:-/home/daemon/.daemon}
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R daemon "$DATA_DIR"
  echo "$0: setting data directory to $DATA_DIR"

  cd $DATA_DIR
  genkeypair > key.txt

  set -- "$@" --
fi

if [ "$1" = "zilliqa" ]; then
  echo
  exec gosu daemon "$@"
fi

echo
exec "$@"


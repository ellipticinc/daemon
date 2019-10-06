#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for monerod"

  set -- monerod "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "monerod" ]; then
  DATA_DIR=${DATA_DIR:-/home/daemon/.daemon}
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R daemon "$DATA_DIR"
  cp /bitmonero.conf $DATA_DIR/bitmonero.conf

  echo "$0: setting data directory to $DATA_DIR"

  set -- "$@" --data-dir="$DATA_DIR" --non-interactive
fi

if [ "$1" = "monerod" ]; then
  echo
  exec gosu daemon "$@"
fi

echo
exec "$@"


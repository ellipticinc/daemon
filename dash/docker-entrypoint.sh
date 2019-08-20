#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for dashd"

  set -- dashd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "dashd" ]; then
  DATA_DIR=${DATA_DIR:-/home/daemon/.daemon}
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R daemon "$DATA_DIR"
  mv /dash.conf $DATA_DIR/dash.conf

  echo "$0: setting data directory to $DATA_DIR"

  set -- "$@" -datadir="$DATA_DIR"
fi

if [ "$1" = "dashd" ] || [ "$1" = "dash-cli" ] || [ "$1" = "dash-tx" ]; then
  echo
  exec gosu daemon "$@"
fi

echo
exec "$@"

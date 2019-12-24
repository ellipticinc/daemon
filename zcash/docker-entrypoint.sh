#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for zcash"

  set -- zcashd "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "zcashd" ]; then
  DATA_DIR=${DATA_DIR:-/home/daemon/.daemon}
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R daemon "$DATA_DIR"
  
  echo "$0: setting data directory to $DATA_DIR"

  set -- "$@" --datadir="$DATA_DIR" --conf=/zcash.conf
fi

if [ "$1" = "zcashd" ]; then
  echo "running zcashd as daemon user"
  exec gosu daemon "$@"
fi

echo
exec "$@"

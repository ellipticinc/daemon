#!/bin/sh
set -e

if [ $(echo "$1" | cut -c1) = "-" ]; then
  echo "$0: assuming arguments for bitcoind"

  set -- bitcoind "$@"
fi

if [ $(echo "$1" | cut -c1) = "-" ] || [ "$1" = "bitcoind" ]; then
  DATA_DIR=${DATA_DIR:-/home/daemon/.daemon}
  mkdir -p "$DATA_DIR"
  chmod 700 "$DATA_DIR"
  chown -R daemon "$DATA_DIR"
  cp /bitcoin.conf $DATA_DIR/bitcoin.conf

  echo "$0: setting data directory to $DATA_DIR"

  set -- "$@" -datadir="$DATA_DIR"
fi

if [ "$1" = "bitcoind" ] || [ "$1" = "bitcoin-cli" ] || [ "$1" = "bitcoin-tx" ]; then
  echo
  exec gosu daemon "$@"
fi

echo
exec "$@"

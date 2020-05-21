#!/bin/bash

source setup.sh
echo "Running $0 in $PWD"

CONF_PATH=/etc/elliptic/config.toml
mkdir -p /etc/elliptic

if [ -f "$CONF_PATH" ]; then
    cp $CONF_PATH /opt/bnbchaind/config/config.toml
fi


echo password123 | bnbcli keys add apikey
bnbcli api-server --chain-id "Binance-Chain-Tigris" --node tcp://dataseed1.binance.org:80 --laddr tcp://127.0.0.1:8080 --trust-node &


set -ev

su bnbchaind -c "/usr/local/bin/bnbchaind start --home ${BNCHOME} $@"
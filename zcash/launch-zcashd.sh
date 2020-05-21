#!/bin/bash

cp -R /home/zcash-init/. /home/zcash/

CONF_PATH=/tmp/zcash.conf

if [ -f "$CONF_PATH" ]; then
    cp $CONF_PATH /home/zcash/.zcash/zcash.conf
fi

/usr/local/bin/fetch-params.sh
/usr/local/bin/zcashd -printtoconsole "$@"

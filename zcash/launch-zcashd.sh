#!/bin/bash

cp -R /home/zcash-init/. /home/zcash/

/usr/local/bin/fetch-params.sh
/usr/local/bin/zcashd -printtoconsole "$@"

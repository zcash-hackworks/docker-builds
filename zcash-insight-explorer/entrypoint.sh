#!/bin/bash

set -eo pipefail

if [[ ! -n ${ZCASHD_NETWORK} ]];then
  echo "ZCASHD_NETWORK must be set"
  exit 1
fi
if [[ ! -n ${ZCASHD_RPCUSER} ]];then
  echo "ZCASHD_RPCUSER must be set"
  exit 1
fi
if [[ ! -n ${ZCASHD_RPCPASSWORD} ]];then
  echo "ZCASHD_RPCPASSWORD must be set"
  exit 1
fi
if [[ ! -n ${ZCASHD_ZMQPORT} ]];then
  echo "ZCASHD_ZMQPORT must be set"
  exit 1
fi

case ${ZCASHD_NETWORK} in
  testnet)
    export ZCASHD_RPC_PORT=18232
    ;;
  mainnet)
    export ZCASHD_RPC_PORT=8232
    ;;
  *)
    echo "Error, unknown network: ${ZCASHD_NETWORK}"
    exit 1
    ;;
esac

env | sort

envsubst < bitcore-node.json.template > zc/bitcore-node.json
cd zc
bitcore-node install zcash-hackworks/insight-api-zcash zcash-hackworks/insight-ui-zcash

if [[ $ZCASHD_NETWORK == 'testnet' ]];then
  sed -i 's/testnet = false/testnet = true/g' node_modules/insight-ui-zcash/public/src/js/app.js
fi

node_modules/bitcore-node-zcash/bin/bitcore-node start

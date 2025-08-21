#!/bin/bash
PathToFile="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source ${PathToFile}/scripts/config.log
keyidnum=1
if [ $# -ne 4 ]; then
  echo "Usage: bash ${PathToFile}/ClientKeyGen.sh <KEYID> <DNS> <PORT> <KEYNAME>"
  echo ""
  echo "DNS - your IP or Domain name of VPN node"
  echo "PORT - your port to connect (default 443)"
  echo "KEYNAME - Any word you want. Used to recognize users"
  echo "KeyIDs found in config.log file:"
  for var in ${!SHORT@}; do
    echo "${keyidnum}. ${!var}"
    ((keyidnum++))
  done
  exit 1
fi


KEYID=$1
DNS=$2
PORT=$3
KEYNAME=$4

echo "Created key:"
echo "vless://${SERVERID}@${DNS}:${PORT}?type=tcp&security=reality&pbk=${PUBKEY}&fp=chrome&sni=www.${WEBSITE}&sid=${KEYID}&flow=xtls-rprx-vision#${KEYNAME}"

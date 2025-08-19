#!/bin/bash

if [ $# -ne 4 ]; then
  echo "Usage: $0 <KEYID> <DNS> <PORT> <KEYNAME>"
  exit 1
fi

SERVEID="SERVERID as in ConfigMap"
SERVERPUB="SERVERPUBKEY as in ConfigMap"
SERVERCNI="WEBSITE.DOMAIN"

KEYID=$1
DNS=$2
PORT=$3
KEYNAME=$4

echo "Created key:"
echo "vless://${SERVERID}@${DNS}:${PORT}?type=tcp&security=reality&pbk=${SERVERPUB}&fp=chrome&sni=${SERVERCNI}&sid=${KEYID}&flow=xtls-rprx-vision#${KEYNAME}"

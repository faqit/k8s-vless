#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Use root or SUDO" >&2
  exit 1
fi

PathToScript="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

privkeygen=$(openssl genpkey -algorithm X25519)

privkey=$(echo "$privkeygen"  | openssl pkey -outform DER | tail -c 32 | base64 | tr '+/' '-_' | tr -d '=')

pubkey=$(echo "$privkeygen" | openssl pkey -pubout -outform DER | tail -c 32 | base64 | tr '+/' '-_' | tr -d '=')

echo "PRIVKEY=\"${privkey}\"" >> $PathToScript/config.log
echo "PUBKEY=\"${pubkey}\"" >> $PathToScript/config.log

echo "Public and Private keys was writen to ${PathToScript}/config.log"

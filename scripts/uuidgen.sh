#!/bin/bash

if [[ $EUID -ne 0 ]]; then
  echo "Use root or SUDO" >&2
  exit 1
fi

PathToScript="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

UUIDGEN=$(openssl rand -hex 16 | sed 's/\(........\)\(....\)\(....\)\(....\)\(............\)/\1-\2-\3-\4-\5/')
echo "SERVERID=\"${UUIDGEN}\"" >> ${PathToScript}/config.log
echo "UUID writed to ${PathToScript}/config.log"

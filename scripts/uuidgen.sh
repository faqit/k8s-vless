#!/bin/bash

PathToScript="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

UUIDGEN=$(openssl rand -hex 16 | sed 's/\(........\)\(....\)\(....\)\(....\)\(............\)/\1-\2-\3-\4-\5/')
echo "$UUIDGEN" >> ${PathToScript}/configlog.log
echo "UUID writed to ${PathToScript}/configlog.log"

#!/bin/bash
if [[ $EUID -ne 0 ]]; then
  echo "Use root or SUDO" >&2
  exit 1
fi
PathToFile="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

read -p "Type masquerade site without www. (example: mysite.com) > " WEBSITE
echo "WEBSITE=\"${WEBSITE}\"" >> ${PathToFile}/config.log

bash $PathToFile/uuidgen.sh
bash $PathToFile/keygen.sh

SHORTID1=$(openssl rand -hex 6)
SHORTID2=$(openssl rand -hex 6)

source ${PathToFile}/config.log

echo "SHORTID1=\"${SHORTID1}\"" >> ${PathToFile}/config.log
echo "SHORTID2=\"${SHORTID2}\"" >> ${PathToFile}/config.log

cd ${PathToFile}
cd ..
sed -e "s|{{WEBSITE}}|$WEBSITE|g" \
    -e "s|{{SERVERID}}|$SERVERID|g" \
    -e "s|{{PUBKEY}}|$PUBKEY|g" \
    -e "s|{{PRIVKEY}}|$PRIVKEY|g" \
    -e "s|{{SHORTID1}}|$SHORTID1|g" \
    -e "s|{{SHORTID2}}|$SHORTID2|g" \
    k3s/configmap-xray-template.yaml > "k3s/configmap-xray.yaml"

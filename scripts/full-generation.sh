#!/bin/bash
if [[ $EUID -ne 0 ]]; then
  echo "Use root or SUDO" >&2
  exit 1
fi
PathToFile="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cd ${PathToFile}
cd ..

read -p "Type masquerade site without www. (example: mysite.com) > " WEBSITE
echo "WEBSITE=\"${WEBSITE}\"" >> ${PathToFile}/config.log

bash $PathToFile/uuidgen.sh
bash $PathToFile/keygen.sh

SHORTID1=$(openssl rand -hex 6)
SHORTID2=$(openssl rand -hex 6)

source ${PathToFile}/config.log
source k3s/templates/affinityblock

echo "Configuring ConfigMap.."

echo "SHORTID1=\"${SHORTID1}\"" >> ${PathToFile}/config.log
echo "SHORTID2=\"${SHORTID2}\"" >> ${PathToFile}/config.log

sed -e "s|{{WEBSITE}}|$WEBSITE|g" \
    -e "s|{{SERVERID}}|$SERVERID|g" \
    -e "s|{{PUBKEY}}|$PUBKEY|g" \
    -e "s|{{PRIVKEY}}|$PRIVKEY|g" \
    -e "s|{{SHORTID1}}|$SHORTID1|g" \
    -e "s|{{SHORTID2}}|$SHORTID2|g" \
    k3s/templates/configmap-xray-template.yaml > "k3s/configmap-xray.yaml"

echo "ConfigMap is configured!"
echo "Configuring Service..."
echo ""

echo "Do you want to change connection port (default 443)?"
echo "Recommend to stay at 443 for your security"

while true; do
    read -p "Change port? (Y)es/(N)o: " portAnswer
    portAnswer=${portAnswer,,}
    if [[ "$portAnswer" == "yes" || "$portAnswer" == "y" ]]; then
        read -p "Type port: " PORT
        if [[ "$PORT" =~ ^-?[0-9]+$ ]]; then
            echo "OK!"
            break
        else
            echo "You need to type number, not a text"
       fi
    elif [[ "$portAnswer" == "no" || "$portAnswer" == "n" ]]; then
        echo "Default port (443) will be used"
        PORT=443
        break
    else
        echo "Incorrect input, Type (Y)es/(N)o"
    fi
done

sed -e "s|{{PORT}}|$PORT|g" \
    k3s/templates/service-xray-template.yaml > "k3s/service-xray.yaml"

echo "Service is configured!"
echo "Configuring DaemonSet..."

echo "Would you use your Master-node for VPN deployment?"
echo "If yes, then this deployment will work on every node, of no - only on worker nodes"

while true; do
    read -p "(Y)es/(N)o: " depAnswer
    depAnswer=${depAnswer,,}
    if [[ "$depAnswer" == "yes" || "$depAnswer" == "y" ]]; then
        echo "OK! Deleting Affinity part"
        sed "/{{AFFINITY}}/d" k3s/templates/dep-xray-template.yaml > "k3s/dep-xray.yaml"
        break
    elif [[ "$depAnswer" == "no" || "$depAnswer" == "n" ]]; then
        echo "OK!"
        awk -v aff="$af" '/{{AFFINITY}}/{print aff; next} 1' \
          k3s/templates/dep-xray-template.yaml > k3s/dep-xray.yaml
        break
    else
        echo "Incorrect input, Type (Y)es/(N)o"
    fi
done

echo "DaemonSet is configured!"
echo ""
echo "You can run your VLESS now or later"
echo "Do you want to start VPN now?"
while true; do
    read -p "(Y)es/(N)o: " runVPN
    runVPN=${runVPN,,}
    if [[ "$runVPN" == "yes" || "$runVPN" == "y" ]]; then
        echo "Starting VLESS"
        bash ${PathToFile}/applyk8s.sh
        break
    elif [[ "$runVPN" == "no" || "$runVPN" == "n" ]]; then
        echo "OK! You can run it via ${PathToFile}/applyk8s.sh"
        break
    else
        echo "Incorrect input, Type (Y)es/(N)o"
    fi
done

echo "You can use v2rayNG or Hiddify clients to connect!"
echo "To generate connecting key use ClientKeyGen.sh in root directory"
echo "!!! Do not forget to open your ${PORT} PORT in firewall !!!"

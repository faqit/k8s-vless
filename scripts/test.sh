#!/bin/bash
cd /etc/git/xray/
source /etc/git/xray/scripts/affinityblock
echo $af
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


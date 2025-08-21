#!/bin/bash

PathToFile="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f ${PathToFile}/k3s/dep-xray.yaml
kubectl apply -f ${PathToFile}/k3s/service-xray.yaml
kubectl apply -f ${PathToFile}/k3s/configmap-xray.yaml

echo "Everything is applied!"


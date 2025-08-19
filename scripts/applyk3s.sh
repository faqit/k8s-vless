#!/bin/bash

kubectl apply -f ../k3s/dep-xray.yaml
kubectl apply -f ../k3s/service-xray.yaml
kubectl apply -f ../k3s/configmap-xray.yaml

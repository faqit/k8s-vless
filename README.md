# K8S XRAY-VLESS TCP-BASED

Whole pack - DaemonSet, Service and ConfigMap

## !!! CONFIGS SHOULD BE CONFIGURED !!!
You need to add some short IDs for clients, ID of your server and website you are masquerading as. (look at comments in ConfigMap file)
Also, there is easy script to generate keys for your proxy.

## USAGE
To correct run you need at least 2 nodes - master and worker.
You can change that by configuring dep-xray.yml and deleting
<
affinity:
NodeAffinity:
equiredDuringSchedulingIgnoredDuringExecution:
nodeSelectorTerms:
- matchExpressions:
- key: node-role.kubernetes.io/control-plane
operator: DoesNotExist
>
part.

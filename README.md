# K8S XRAY-VLESS TCP-BASED

Whole pack - DaemonSet, Service and ConfigMap

## !!! CONFIGS SHOULD BE CONFIGURED !!!
You need to add some short IDs for clients, ID of your server and website you are masquerading as. (look at comments in ConfigMap file)  

## USAGE
To correct run you need at least 2 nodes - master and worker.  
You can change that by configuring dep-xray.yml and deleting "affinity" part.  

To find site you want to hide for use this command  
curl -I --tlsv1.3 --http2 https://example.com  

## Scripts
I leaved in root directory the "ClientKeyGen.sh" script, which can help you to create you first key. Do not forget to add your own params to script!  
Also, there is ./scripts directory, which contains all basic scripts for prepare your system. If you want to do "All in one" just run "full-generation.sh".  
It will create Public&Private key pair, generate uuid for your server in proper format and type it in config.log file with comments.  
You can apply k8s config by yourself, but if you dont want - there is script named "applyk8s.sh"

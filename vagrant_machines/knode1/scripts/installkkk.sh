#!/bin/bash
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
#KUBE_VERSION=1.10.1-00
KUBE_VERSION=1.11.3-00
apt-get update
sudo apt-get install -y --allow-downgrades kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION
#Fixing to secondary network
LOCAL_IP=$1
sudo sed -i 's/KUBELET_EXTRA_ARGS=.*/KUBELET_EXTRA_ARGS=--node-ip='$LOCAL_IP'/' /etc/default/kubelet
systemctl daemon-reload
systemctl restart kubelet

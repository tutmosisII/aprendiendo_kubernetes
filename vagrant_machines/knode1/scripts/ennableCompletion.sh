#!/bin/bash
#Ennable command completion
echo "source <(kubectl completion bash)"|sudo tee -a /etc/bash.bashrc
echo "source <(kubeadm completion bash)"|sudo tee -a /etc/bash.bashrc
#Fixing to secondary network
LOCAL_IP=$1
sudo sed -i 's/KUBELET_EXTRA_ARGS=.*/KUBELET_EXTRA_ARGS=--node-ip='$LOCAL_IP'/' /etc/default/kubelet

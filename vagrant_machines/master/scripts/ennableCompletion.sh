#!/bin/bash
#Ennable command completion
echo "source <(kubectl completion bash)"|sudo tee -a /etc/bash.bashrc
echo "source <(kubeadm completion bash)"|sudo tee -a /etc/bash.bashrc
#Showing join command
grep "adm.*join" /vagrant/scripts/kubeadm.log

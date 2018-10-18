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
#Configuring kubectl to the secondary vm network
echo "secondary IP vagrant: $1"
LOCAL_IP=$1
sudo sed -i 's/KUBELET_EXTRA_ARGS=.*/KUBELET_EXTRA_ARGS=--node-ip='$LOCAL_IP'/' /etc/default/kubelet
systemctl daemon-reload
systemctl restart kubelet

function install_with_CNI_flanel () {
  wget -O kube-flannel.yml https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  FLANNEL_NETWORK=$(grep "Network.*/16" kube-flannel.yml|nawk '{print substr($2,2,length($2)-3)}')
  kubeadm init --pod-network-cidr $FLANNEL_NETWORK 2>&1 kubeadm.log
}

function install_with_CNI_calico () {
  wget -O /tmp/calico.yml  https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/calico.yaml
  CALICO_NETWORK=$(grep "value.*/16" /tmp/calico.yml|nawk '{print substr($2,2,length($2)-2)}')
  echo "Calico Network to use $CALICO_NETWORK"
  pwd
  NODENAME=$(hostname -s)
  kubeadm init --apiserver-cert-extra-sans $LOCAL_IP  --node-name $NODENAME --apiserver-advertise-address $LOCAL_IP --pod-network-cidr $CALICO_NETWORK 2>&1 > kubeadm.log
}



install_with_CNI_calico $1
sleep 5
mkdir $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo cp -i /etc/kubernetes/admin.conf /vagrant/config
sudo chown $(id -u ):$(id -g) $HOME/.kube/config
echo "Configuring Calico Network"
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/etcd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/rbac.yaml
kubectl apply -f /tmp/calico.yml
#Ennable command completion
echo "source <(kubectl completion bash)" >> /etc/bash.bashrc

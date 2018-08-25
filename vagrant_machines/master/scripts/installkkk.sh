#!/bin/bash
apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
#KUBE_VERSION=1.10.1-00
KUBE_VERSION=1.11.2-00
apt-get update
sudo apt-get -y install docker-ce=17.03.2~ce-0~ubuntu-xenial
sudo apt-get install -y --allow-downgrades kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION

function install_with_CNI_flanel () {
  wget -O kube-flannel.yml https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
  FLANNEL_NETWORK=$(grep "Network.*/16" kube-flannel.yml|nawk '{print substr($2,2,length($2)-3)}')
  kubeadm init --pod-network-cidr $FLANNEL_NETWORK 2>&1 kubeadm.log
}

function install_with_CNI_calico () {
  wget -O calico.yml  https://docs.projectcalico.org/v2.6/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
  CALICO_NETWORK=$(grep "value.*/16" calico.yml|nawk '{print substr($2,2,length($2)-2)}')
  echo "Calico Network to use $CALICO_NETWORK"
  kubeadm init --pod-network-cidr $CALICO_NETWORK 2>&1 kubeadm.log
}

install_with_CNI_calico
sleep 5
echo "Configuring user permisions"
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
echo "Configuring Calico Network"
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/etcd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/rbac.yaml
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/calico.yaml
kubectl apply -f https://docs.projectcalico.org/v3.2/getting-started/kubernetes/installation/hosted/calico.yaml
kubectl taint nodes --all node-role.kubernetes.io/master-

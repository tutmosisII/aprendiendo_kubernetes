apt-get update && apt-get install -y apt-transport-https curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
#KUBE_VERSION=1.10.1-00
KUBE_VERSION=1.11.2-00
apt-get update
sudo apt-get -y install docker-ce=17.03.2~ce-0~ubuntu-xenial
apt-get install -y --allow-downgrades kubelet=$KUBE_VERSION kubeadm=$KUBE_VERSION kubectl=$KUBE_VERSION
wget -O kube-flannel.yml https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
FLANNEL_NETWORK=$(grep "Network.*/16" kube-flannel.yml|nawk '{print substr($2,2,length($2)-3)}')
kubeadm init --pod-network-cidr $FLANNEL_NETWORK 2>&1 kubeadm.log
grep -i token kubeadm.log

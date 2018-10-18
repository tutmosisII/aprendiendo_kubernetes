#!/bin/bash
mkdir -p $HOME/.kube/vagrant/
cp ../vagrant_machines/master/config $HOME/.kube/vagrant/config
function dashboard() {
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
  kubectl proxy
}
function creandoAdmin(){

}
function metric_server(){

}
dashboard &
creandoAdmin
metric_server
x-www-browser http://localhost:8001/api/v1/namespaces/kube-system/services/https:kubernetes-dashboard:/proxy/

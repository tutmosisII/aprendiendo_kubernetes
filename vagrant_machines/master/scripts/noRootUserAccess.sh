#!/bin/bash
mkdir ~vagrant/.kube
sudo cp -i /etc/kubernetes/admin.conf ~vagrant/.kube/config
sudo chown -R $(id -u vagrant):$(id -g vagrant) ~vagrant/.kube

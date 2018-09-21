#!/bin/bash
mkdir ~vagrant/.kube
sudo chown -R $(id -u vagrant):$(id -g vagrant) ~vagrant/.kube

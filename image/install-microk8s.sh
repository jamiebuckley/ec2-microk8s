#!/bin/sh
set -e

sudo apt-get update -y
sudo apt-get upgrade -y

sudo snap install microk8s --classic
sudo microk8s status --wait-ready
sudo microk8s enable dashboard dns registry helm ingress

sudo usermod -a -G microk8s ubuntu
sudo chown -f -R ubuntu ~/.kube

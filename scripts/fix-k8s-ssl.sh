#! /bin/bash

PUBLIC_HOSTNAME=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)

sed -i "/^DNS.5.*/a DNS.100 = $PUBLIC_HOSTNAME" /var/snap/microk8s/current/certs/csr.conf.template
sed -i "/^IP.2.*/a IP.100 = $PUBLIC_IP" /var/snap/microk8s/current/certs/csr.conf.template

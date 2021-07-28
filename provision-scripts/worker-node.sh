#! /bin/bash

/bin/bash /vagrant/cluster-config/join-command.sh

sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -R /vagrant/configs/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
NODENAME=$(hostname -s)
kubectl label node $(hostname -s) node-role.kubernetes.io/worker=worker-new
EOF
#! /bin/bash

##Set Environment Vaiable
MASTER_NODE_IP="192.168.100.100"
POD_NETWORK_CIDR="192.168.10.0/22"

### Create cluster
sudo kubeadm init --pod-network-cidr=$POD_NETWORK_CIDR  --apiserver-advertise-address=$MASTER_IP 

### Setup kubectl for root user. 
mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

###Setup cluster config for workers node.
cluster_config="/vagrant/cluster-config"
if [ -d $cluster_config ]; then
   rm -f $cluster_config/*
else
   mkdir -p $cluster_config
fi

cp -i /etc/kubernetes/admin.conf /vagrant/cluster-config/config

kubeadm token create --print-join-command > /vagrant/cluster-config/join-command.sh


### Setup kubectl for vagrant user. 
sudo -i -u vagrant bash << EOF
mkdir -p /home/vagrant/.kube
sudo cp -i /vagrant/cluster-config/config /home/vagrant/.kube/
sudo chown 1000:1000 /home/vagrant/.kube/config
EOF


## Install weave network plugin 
kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

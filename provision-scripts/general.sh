#! /bin/bash

### This bootstrap as per the k8s doc 
### https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/ 

################  Install Docker ################
echo "Installing Docker"
sudo apt-get update -y
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

echo \
  "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y
sudo apt-get install docker-ce docker-ce-cli containerd.io -y
 
### Configure Cgroup docker driver as systemd. https://kubernetes.io/docs/setup/production-environment/container-runtimes/#docker

echo "Setting up systemd driver"
cat <<EOF | sudo tee /etc/docker/daemon.json
{
  "exec-opts": ["native.cgroupdriver=systemd"],
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "100m"
  },
  "storage-driver": "overlay2"
}
EOF

sudo systemctl enable docker
sudo systemctl daemon-reload
sudo systemctl restart docker

### Gettting docker driver setting info
sudo docker info | grep -i driver

echo "Docker install completed"


# Disable swap
sudo swapoff -a

# Keeps the swap off permanently, so it won't on after reboot.
sudo sed -i '/ swap / s/^\(.*\)$/#\1/g' /etc/fstab

################  Install Kubelet Kubectl and kubeadm with specific version. ################

# Settting up Version 
k8S_VERSION="1.20.6-00"

echo "Installing kubeadm=$k8S_VERSION, kubectl=$k8S_VERSION, kubelet=$k8S_VERSION"
### Setting up dependencey and Installl them. 
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl
sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update -y
sudo apt-get install -y kubeadm=$k8S_VERSION kubectl=$k8S_VERSION kubelet=$k8S_VERSION 
sudo apt-mark hold kubectl kubelet kubeadm 


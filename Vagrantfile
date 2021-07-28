Vagrant.configure("2") do |config|
    config.vm.provision "shell", inline: <<-SHELL
        sudo apt-get update -y
        echo "192.168.100.100  k8s-master" >> /etc/hosts
        echo "192.168.100.101  k8s-worker-01" >> /etc/hosts
        echo "192.168.100.102  k8s-worker-02" >> /etc/hosts
    SHELL
    
    config.vm.define "master" do |master|
      master.vm.box = "bento/ubuntu-18.04"
      master.vm.hostname = "master"
      master.vm.network "private_network", ip: "192.168.100.100"
      master.vm.provider "virtualbox" do |vb|
          vb.memory = 4048
          vb.cpus = 2
      end
      master.vm.provision "shell", path: "provision-scripts/general.sh"
      master.vm.provision "shell", path: "provision-scripts/master-node.sh"
    end

    (1..2).each do |count|
  
    config.vm.define "worker-#{count}" do |worker|
    worker.vm.box = "bento/ubuntu-18.04"
    worker.vm.hostname = "worker-#{count}"
    worker.vm.network "private_network", ip: "192.168.100.10#{count}"
    worker.vm.provider "virtualbox" do |vb|
          vb.memory = 2048
          vb.cpus = 1
      end
      worker.vm.provision "shell", path: "provision-scripts/general.sh"
      worker.vm.provision "shell", path: "provision-scripts/worker-node.sh"
    end
    
    end
  end

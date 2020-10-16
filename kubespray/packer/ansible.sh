#!/bin/bash
export PATH=$PATH:$HOME/.local/bin
export DEBIAN_FRONTEND=noninteractive
set -euo pipefail
sudo apt update
sudo apt install -y software-properties-common
sudo add-apt-repository universe
sudo apt update
sudo apt install -y python3-pip curl wget #python3-setuptools #python3-virtualenv 

if [ ! -d kubespray ] ; then
    DIR=$(curl -s https://api.github.com/repos/kubernetes-sigs/kubespray/releases/latest | grep "tarball_url" | cut -d : -f 2,3 | \
    tr -d \" | tr -d "," | wget -qi - -O- | tar xzv | tac | tail -n 1 ) # Download latest Kubespray release, extract it and move to "kubespray"
    mv $DIR kubespray
    ln -s kubespray/ansible.cfg ansible.cfg
fi 
pip3 install --user -r kubespray/requirements.txt
cp -rfp kubespray/inventory/sample/ kubespray/cluster
IP=$(ansible localhost -m setup -a 'filter=ansible_default_ipv4' | grep \"address\" | awk '{print $2}' | cut -d'"' -f2)
CONFIG_FILE=kubespray/cluster/hosts.yaml python3 kubespray/contrib/inventory_builder/inventory.py $IP
echo | ssh-keygen
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys
ansible-playbook kubespray/cluster.yml -i kubespray/cluster/hosts.yaml --become --become-user root


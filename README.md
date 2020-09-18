### RELEASE 0.1 OVA

Release 0.1 includes the completed/tested pieces of the Reverse Proxy project as a "docker-compose script" to run inside an standard Ubuntu 18.04 server OVA image. The completed pieces of this project so far are:

- Squid based reverse Proxy for a specific website.
- Two Way URL rewrite/ with the help of NGINX in front of Squid.
- SSL termination.
- ICAP integration (icap://gw-icap01.westeurope.azurecontainer.io/gw_rebuild)

## Instructions:
- Download the OVA http://51.11.8.179:1234/glasswall-proxy.ova
- Import it to VirtualBox , open settings, choose the network for network adapter 2
- system credentials:
username: user
password: secret
- check the ip address of eth1, add it your hosts files as follows

  `1.2.3.4 assets.publishing.service.gov.uk.glasswall-icap.com`

  `1.2.3.4 gov.uk.glasswall-icap.com`

  `1.2.3.4 www.gov.uk.glasswall-icap.com `


**Credits**

OVA Packer scripts by NourEddineX
reverse-proxy-icap-docker by NourEddineX and yassin


### USING RELEASE 1 OVA - FastTrack 

- Download OVA file from: https://hcompl-my.sharepoint.com/:u:/g/personal/mariusz_ferdyn_h_com_pl/EaOCuPCAb9VGjL-Fk2KWK6sBvg1j5V0g-eiwOyNVXfisRA?e=oxl4zu
- Open VirtualBox
- Import downloaded OVA file: glasswal-proxy.ova

Expected Result: File is successfully imported

- Once OVA is imported, go to Settings>Network>Adapter 2

Expected Result: 

Attached to: Host-Only Adapter
Name: VirtualBox Host-Only Ethernet Adapter

- Start the glasswall-proxy
- Login (username: user, password: secret)
- In shell type

ip a

check the ip address for eth1 (this address is used in the following step)

- In your hosts file (on win: C:\Windows\System32\drivers\etc, on MAC/Linux: /etc/hosts) add following lines
``` bash
<IPADDRESS STEP7>  assets.publishing.service.gov.uk.glasswall-icap.com
<IPADDRESS STEP7>  gov.uk.glasswall-icap.com
<IPADDRESS STEP7>  www.gov.uk.glasswall-icap.com
```
-Open any browser and try to access: www.gov.uk.glasswall-icap.com

The page will pop up the warnings, ignore them all, and continue. 


- In case of error - Nonexisiting network choose a different network type for network adapter 1 and 2, save it and back for network adapter 1 - NAT and for network adapter 2 host only.
- In case you experience any issues, in VirtualBox cmd try running:
``` bash
sudo systemctl status docker
```
- make sure docker is running
- If there is a need to bring docker up
``` bash
cd reverse-proxy-icap-docker
docker-compose ps
```
- If squid is not started correctly
``` bash
docker-compose up -d --force-recreate squid
```
- In case there is a need to reboot:
``` bash
sudo reboot
```


### Create OVA with docker-compose container from https://github.com/filetrust/k8-reverse-proxy/tree/master/upwork-devs/noureddine-yassin/reverse-proxy-icap-docker

**Prepare Environment**

- Install Git for Windows (Default Settings) https://gitforwindows.org/ or a better option is to install to download and install Tortoisegit https://tortoisegit.org/download/
- Install Virtual Box (Default Settings, You can not use Hyper-V): https://download.virtualbox.org/virtualbox/6.1.14/VirtualBox-6.1.14-140239-Win.exe
	
	You can create a new Empty Virtual Machine and start it to see Bios - In this way you are sure that Hypervisor is running properly.

- Install Vagrant(Default Settings): https://releases.hashicorp.com/vagrant/2.2.10/vagrant_2.2.10_x86_64.msi
- Copy .exe from https://releases.hashicorp.com/packer/1.6.2/packer_1.6.2_windows_amd64.zip to c:\windows\system32


**Build Steps**

Clone the Repo

``` bash
git clone https://github.com/filetrust/k8-ova.git
```

Go to the `Release01` Directory

``` bash
cd k8-ova/Release01
```

Clone the reverse proxy repo and tweak configuration files as described in k8-reverse-proxy/upwork-devs/noureddine-yassin/README.md - especially set correct ICAP server.

```bash
git clone https://github.com/filetrust/k8-reverse-proxy.git
```

make an archive from reverse-proxy-icap-docker folder

```bash
rm revproxy.tar.gz
tar czvf revproxy.tar.gz -C k8-reverse-proxy/Release01/ reverse-proxy-icap-docker/
```

The previous command doesn't work under Windows, so in this repo version, https://github.com/filetrust/k8-reverse-proxy/tree/e4a5a5238a565fc82395d56d2388a80ce30375f8 is included - revproxy.tar.gz.

Build the Image

``` bash
packer build box.json
```

After Successful build

Import the OVA file by going into the `output-virtualbox-iso` and Import the Image by **Double** clicking the ova file


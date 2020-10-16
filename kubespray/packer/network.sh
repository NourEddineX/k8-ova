#!/bin/bash
sed -i 's/GRUB_CMDLINE_LINUX=""/GRUB_CMDLINE_LINUX="net.ifnames=0 biosdevname=0"/g' /etc/default/grub
update-grub
rm -f /etc/netplan/*.yml /etc/netplan/*.yaml
cat > /etc/netplan/network.yaml <<EOF
network:
  version: 2
  ethernets:
    eth0:
      addresses:
        - $( ip addr show $(ip route |grep default |head -n1|grep -o -P '(?<=dev )[a-z0-9]{2,20}') | grep -o -P '(?<=inet )[0-9./]{9,18}' )
      gateway4: $( ip route |grep default |head -n1|grep -o -P '(?<=via )[0-9.]{7,15}' )
      dhcp4: false
    eth1:
      dhcp4: true
EOF

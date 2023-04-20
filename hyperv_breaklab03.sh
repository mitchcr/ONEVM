#!/bin/bash
sudo -i
sed -i '/^[^#]/ s/\(^.*storvsc".*$\)/#\ \1/' /etc/dracut.conf
sed -i -e '$aomit_drivers+="hv_vmbus hv_netvsc hv_storvsc"' /etc/dracut.conf
cd /boot
dracut -f -v initramfs-`uname -r`.img kernel-`uname -r`
shutdown -r +1

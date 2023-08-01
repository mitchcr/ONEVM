#!/bin/bash

#Custom script to damage Lab2 for Initrd module.

#Commenting out add_drivers+="hv_vmbushv_netvschv_storvsc" in /etc/dracut.conf
sed -i 's/add_drivers+="hv_vmbus hv_netvsc hv_storvsc"/\#add_drivers+="hv_vmbus hv_netvsc hv_storvsc"/' /etc/dracut.conf

#Get the hv_storvsc module not becoming part of the initrd file.
echo "omit_drivers+=\"hv_vmbus hv_netvsc hv_storvsc\"" >> /etc/dracut.conf

#Recreate the initrd
dracut -f /boot/initramfs-3.10.0-327.59.1.el7.x86_64.img 3.10.0-327.59.1.el7.x86_64

#Reboot the VM
shutdown -r +1

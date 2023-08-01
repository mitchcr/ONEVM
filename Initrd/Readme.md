# Greater Insight Initrd Lab

## About this Lab


- This Lab was created for Greater Insight Initrd.
- It will take approximately 60 minutes 
- This lab has three activities:
  
> 1. Fix VM noboot issue caused by corrupt initrd/initramfs.
> 2. Fix VM noboot issue caused by missing hv_storvsc of LIS driver in initrd/initramfs.
> 3. Fix VM noboot issue caused by missing LIS driver in initrd/initramfs.


## Lab 1: Fix VM no boot issue caused by corrupt initrd/initramfs

### Instructions
1. Deploy one RHEL 7.9 Broken VM using the link below: 

  [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fInitrd%2fLab01.json)

2. Check on the VM Serial Console log and Boot Diagnostics screenshot and Serial log to confirm the no-boot status.  VM is in a non-boot scenario due to corrupt initramfs/initrd for current kernel.
3. Create a Repair VM and attach an OS disk copy of damage VM as data disk.
4. Create and connect to a chroot environment following the public documentation: [Chroot environment in a Linux rescue VM](https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/chroot-environment-linux)
5. Take a backup of current iniramfs/initrd file using command **cp**
6. Rebuild initramfs, remember to keep the appropiate path while executing this command:

   `# dracut -f -v initramfs-<kernel=version>.img <kernel-version>`
   
7. Exit chroot environmet and umount OS disk copy, then proceed to swap the OS disk in the failing VM.
8. Start the VM and verify the VM is booting as expected.

**NOTE:**  Another way to fix this scenario is using ALAR scripts you can find more information here: [Use Azure Linux Auto Repair (ALAR) to fix a Linux VM](https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/repair-linux-vm-using-alar)


## Lab 2: Fix VM noboot issue caused by missing hv_storvsc of LIS driver in initrd/initramfs
### Scenario

On this Lab the hv_storvsc driver has been removed from the Initrd configuration.

Your task is to set a repair VM to fix the situation.

Once you've added the missing driver into the Initrd configuration file, make the necessary configuration changes to ensure the VM boots up properly.

### Symptom

![initramfs file corrupted](https://github.com/mitchcr/ONEVM/blob/main/Initrd/GutHub%20-%20initramfs%20-%20lab%202%20error.png)

### Instructions

1.  Deploy one Broken RHEL 7.2 Gen1 without LVM VM using the link below:

  [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fInitrd%2fLab02.json)

2. Check in Serial Console log and Boot Diagnostics that VM is in a non-boot scenario and check on the error.
3. Create a Repair VM environment and attach a OS disk copy to this environment as data disk.
4. Create and connect to a chroot environment following the public documentation: [Chroot environment in a Linux rescue VM](https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/chroot-environment-linux)
5. Create a backup of the problematic initramfs using command *cp*
6. Modify configuration and rebuild the Initrd for the current kernel using the command below (*Remember to include the correct path on the command*):
 
          #vi /etc/dracut.conf
          add_drivers+="hv_vmbus hv_netvsc hv_storvsc"
          #dracut -f -v <initramfsversion> <kernelversion>

7. Exit chroot and unmount the OS disk copy from the troubleshooting VM, after you've done that, reassemble the original VM by switching the OS disk.

8. The VM should be now able to boot after Initrd configuration gets changed.

## Lab 3: Fix VM non-boot issue caused by missing of all LIS driver in Initrd
### Instructions
1. Deploy one broken VM with RHEL 7.2 Gen 1 without LVM using the link below:

 [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fInitrd%2fLab03.json)

2. Check in Serial Console log and Boot Diagnostics that VM is in a non-boot scenario and check on the error.
3. Create a Repair VM environment and attach a OS disk copy to this environment as data disk.
4. Create and connect to a chroot environment following the public documentation: [Chroot environment in a Linux rescue VM](https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/chroot-environment-linux)
5. Modify configuration and rebuild the Initrd for the current kernel using the command below (*Remember to include the correct path on the command*):
 
          #vi /etc/dracut.conf
          add_drivers+="hv_vmbus hv_netvsc hv_storvsc" 
          #dracut -f -v <initramfsversion> <kernelversion>

6. Exit chroot and unmount the OS disk copy from the troubleshooting VM, after you've done that, reassemble the original VM by switching the OS disk.

8. The VM should be now able to boot after Initrd configuration gets changed.




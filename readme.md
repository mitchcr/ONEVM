# Greater Insight Initrd Lab

About this Lab:


This Lab was created for Greater Insight Initrd.
It will take approximately 60 min and it has three activities:  

> 1. Fix VM noboot issue caused by corrupt initrd.
> 2. Fix VM noboot issue caused by missing hv_storvsc of LIS driver in Initrd.
> 3. Fix VM noboot issue caused by missing LIS driver in Initrd.
>

## Lab 1: Fix VM noboot issue caused by corrupt Initrd

*On this Lab the **initramfs file** for the VM got corrupted causing the VM to enter into a non-boot state.* 

*Your task is to set a Nested environment using one of the Solution Methods provided below in order to regenerate the initramfs file.*

*Once the initramfs file has been restored, make the necessary configuration changes to ensure the VM boots up properly.*

### Symptom

![initramfs file corrupted](https://github.com/kaalvara/initramfs/blob/main/GitHub%20-%20initramfs%20-%20error.png)

### How to fix it? 

Deploy the RHEL 7.9 Broken VM using the link below: 

  [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkaalvara%2Finitramfs%2Fmain%2FLab01SpecialistJSON.json)

Once the VM has been deployed and you confirmed it is in the problematic state please attach the problematic OS Disk copy to a troubleshooting VM created using your preferred method:
 
### Possible methods to create the Nested environment needed to fix the broken VM:

#### *Method 1 - ALAR*

<details close>

<summary>Click here to expand or collapse this section</summary>

- [*Azure ALAR*][def2]
  
           If you are going to use Azure ALAR steps in order to create the troubleshooting VM and fix this issue; no additional steps are required. 
           Please just confirm the Original broken VM is now working as expected.

</details>

#### *Method 2 - chroot*

<details close>

<summary>Click here to expand or collapse this section</summary>

- [*chroot*][def], 
  
   1. After creating Nested environment following [*chroot*][def] steps please proceed to [step 2](#ii.).

   2. Take a backup of the Old Initrd image and Rebuild the Initrd for the current kernel using the command below (*Remember to include the correct path on the command*):
 
          dracut -f -v <initramfsversion> <kernelversion>

   3. Exit chroot and unmount the OS disk copy from the troubleshooting VM, after you've done that, please reassemble the original VM by switching the OS disk.

   4. The VM should be now able to boot after Initrd configuration gets changed.

[def]: https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/chroot-environment-linux#using-the-same-lvm-image 
[def2]: https://github.com/Azure/ALAR

  </details>
  
  ## Lab 2: Fix VM noboot issue caused by missing hv_storvsc of LIS driver in Initrd.
  
  *On this Lab the *hv_storvsc* driver has been removed from the Initrd configuration.*
 
  *Your task is to set a Nested environment using one of the possible Solution Methods provided below in order to add the missing driver into the Initrd configuration file.*

  *Once you've added the missing driver into the Initrd configuration file, make the necessary configuration changes to ensure the VM boots up properly.*
  
  ### Symptom

![initramfs file corrupted](https://github.com/kaalvara/initramfs/blob/main/GutHub%20-%20initramfs%20-%20lab%202%20error.png)

  ### How to fix it? 

Deploy the *RHEL 6.10 Gen 1 without LVM* Broken VM using the link below: 

  [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkaalvara%2Finitramfs%2Fmain%2FLab02SpecialistJSON.json)

Once the VM has been deployed and you confirmed it is in the problematic state please attach the problematic OS Disk copy to a troubleshooting VM created using your preferred method:
 
### Possible methods to create the Nested environment needed to fix the broken VM:

#### *Method 1 - ALAR*

<details close>

<summary>Click here to expand or collapse this section</summary>

- [*Azure ALAR*][def2]
  
           If you are going to use Azure ALAR steps in order to create the troubleshooting VM and fix this issue; no additional steps are required. 
           Please just confirm the Original broken VM is now working as expected.

</details>

#### *Method 2 - chroot*

<details close>

<summary>Click here to expand or collapse this section</summary>

- [*chroot*][def], 
  
   1. After creating Nested environment following [*chroot*][def] steps please proceed to [step 2](#ii.).

   2. Take a backup of the Old Initrd image and Rebuild the Initrd for the current kernel using the command below (*Remember to include the correct path on the command*):
 
          dracut -f -v <initramfsversion> <kernelversion>

   3. Exit chroot and unmount the OS disk copy from the troubleshooting VM, after you've done that, please reassemble the original VM by switching the OS disk.

   4. The VM should be now able to boot after Initrd configuration gets changed.

[def]: https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/chroot-environment-linux#using-the-same-lvm-image 
[def2]: https://github.com/Azure/ALAR

  </details>
  
## Lab 3: Fix VM noboot issue caused by missing of all LIS driver in initrd
  
  *On this Lab all **LIS drivers** have been removed from the Initrd configuration.*
 
  *Your task is to set a Nested environment using one of the possible Solution Methods provided below in order to add the missing drivers into the Initrd configuration file.*

  *Once you've added the missing driver into the Initrd configuration file, make the necessary configuration changes to ensure the VM boots up properly.*
  
  ### Symptom

![initramfs file corrupted](https://github.com/kaalvara/initramfs/blob/main/Github%20-%20INITRAMFS%20Lab%203%20error.png)

  ### How to fix it? 

Deploy the *RHEL 6.10 Gen 1 without LVM* Broken VM using the link below: 

  [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkaalvara%2Finitramfs%2Fmain%2FLab03SpecialistJSON.json)

Once the VM has been deployed and you confirmed it is in the problematic state please attach the problematic OS Disk copy to a troubleshooting VM created using your preferred method:
 
### Possible methods to create the Nested environment needed to fix the broken VM:

#### *Method 1 - ALAR*

<details close>

<summary>Click here to expand or collapse this section</summary>

- [*Azure ALAR*][def2]
  
           If you are going to use Azure ALAR steps in order to create the troubleshooting VM and fix this issue; no additional steps are required. 
           Please just confirm the Original broken VM is now working as expected.

</details>

#### *Method 2 - chroot*

<details close>

<summary>Click here to expand or collapse this section</summary>

- [*chroot*][def],
  
   1. After creating Nested environment following [*chroot*][def] steps please proceed to [step 2](#ii.).

   2. Take a backup of the Old Initrd image and Rebuild the Initrd for the current kernel using the command below (*Remember to include the correct path on the command*):
 
          #vi /etc/dracut.conf
          add_drivers+="hv_vmbus hv_netvsc hv_storvsc"
          #dracut -f -v <initramfsversion> <kernelversion>

   3. Exit chroot and unmount the OS disk copy from the troubleshooting VM, after you've done that, please reassemble the original VM by switching the OS disk.

   4. The VM should be now able to boot after Initrd configuration gets changed.

[def]: https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/chroot-environment-linux#using-the-same-lvm-image 
[def2]: https://github.com/Azure/ALAR

  </details>

# Greater Insight Initrd Lab

About this Lab:
This Lab was created for Greater Insight Initrd.
It will take approximately 60 min and it has three activities:  

> 1. Fix VM noboot issue caused by corrupt initrd.
> 2. Fix VM noboot issue caused by missing hv_storvsc of LIS driver in Initrd.
> 3. Fix VM noboot issue caused by missing LIS driver in Initrd.
>
## Lab 1: Fix VM noboot issue caused by corrupt Initrd

#### Instructions

Deploy the RHEL 7.9 Broken VM using the link below: 

  [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2Fkaalvara%2Finitramfs%2Fmain%2Fdeploymenttemplatekaalvara.json%0A)

Once the VM has been deployed and you confirmed it is in the problematic state:

 1. Attach the problematic OS Disk copy to troubleshooting VM created using your preferred method:
 
##### Methods to create the Nested environment needed to fix the broken VM:

#### Method 1

<details close>

<summary>Click here to expand or collapse this section</summary>

- [*Azure ALAR*][def2]
  If you are going to use [*Azure ALAR*][def2] steps in order to create the troubleshooting VM and fix this issue; no additional steps are required. Please just confirm the Original broken VM is now working as expected.

</details>

#### Method 2

<details close>

<summary>Click here to expand or collapse this section</summary>

- [*chroot*][def], after creating Nested environment following [*chroot*][def] steps please proceed to [Step 2](#2.).

</details>

2. Take a backup of the Old Initrd image and Rebuild the Initrd for the current kernel using the command below:
 
          dracut -f -v <initramfsversion> <kernelversion>

 3. Exit chroot and unmount the OS disk copy from the troubleshooting VM, after you've done that, please reassemble the original VM by switching the OS disk.

 4. The VM should be now able to boot after Initrd configuration gets changed.

[def]: https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/chroot-environment-linux#using-the-same-lvm-image 
[def2]: https://github.com/Azure/ALAR

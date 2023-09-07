# Storage besides LVM Laboratories

## Lab 1:  LVM
### About this Lab 

- This course/module was created for Module Sotrage besides LVM.
- It will take approximately 45 minutes.
- This module introduces you to the tools to LVM.
- This Lab provides hands-on activities.
- After this course/module you will be able to:
    - Create LVM Disks using Raw and partitioned, Resize and extend the Logical Volume.
    - Extend the existing disk and resize the LVM (in this case LVM is created on top of whole disk).
    - Extend the existing disk and resize the LVM (in this case LVM is created by creating partition on the disk).
    - Extend the existing disk and resize the LVM by creating new partitions.
    - Extend the LV by adding new disk to the VG.
 
### Scenario 1
#### Extend the existing disk and resize the LVM (In this case LVM is created on top of whole disk)

Sometimes there is a need to use LVM as part of a VM for flexibility purposes in terms of mountpoints and filesystems.

In this lab, we are going to create data disks and build LVM volumes on top of them.

#### Deployment instructions

1. Deploy one RHEL VM using the link below:

[![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fStorage%2fStorageLab01.json)


2.  Connect to the VM and switch to root account using the following command:

        sudo -i
3.  Identify the data disk that is not in use on the OS with command:

         lsblk

    The output of that command will be similiar to the one on this example:

    
![lsblk_output](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/lsblkoutput.jpg)

In the output we marked 3 columns, Name, Size and Type.   To identify the disks attached to the VM you can check under the blue rectangle, that's the TYPE column, search for the word "disk" those will be the disks attached to the VM.   So following the previous example we have 3 disks as we can count 3 times the word "disk" under that column.   First column, the one marked in yellow, will provide us the names, following the example those disks are: sda, sdb and sdc.   In this particular case we are searching for one data disk that is empty, not in use, so you can check on the last column (not marked) that is called MOUNTPOINTS and search for the disk that does not have anything there.  Another way is checking on the disk size.  The attached disk has 4 GB, you can search that in the green rectangle.  The disk we will modify following this example will be the disk named sdb.   We will refer to it as /dev/sdb as all the devices in Linux are under /dev directory.    Remember that in Azure we cannot guarantee the device names, so it's possible that in your lab the disk you'll be using can have a different name than the one in this example, proceed to identify it and remember to use the correct names in next commands. 

4. Create a physical volume with command:

        pvcreate <disk>

   Example:

 ![pvcreate](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/pvcreate.jpg)

5. Create a volume group with command:

        vgcreate <volume_group_name> <physical_volume>

   Example:

 ![vgcreate](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/vgcreate.jpg)

6.  Create a logical volume assigning all the free space with command:

        lvcreate -l 100%FREE -n <logical_volume_name> <volume_group_name>

    Example:
    
![lvcreate](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/lvcreate.jpg)

8.  Verify the changes with the following commands:

        pvs  #to check on the physical volumes
        vgs  #to check on the volume groups
        lvs  #to check on the logical volumes

   Example: 

![verify](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/verify.jpg)

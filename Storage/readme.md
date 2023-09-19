# Storage besides LVM Laboratories

[Lab 1: LVM](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md#lab-1--lvm)

- [Scenario 1](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md#scenario-1)
- [Scenario 2](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md#scenario-2)
- [Scenario 3](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md#scenario-3)
- [Scenario 4](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md#scenario-4)

[Lab 2: Azure file share](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md#lab-2-azure-file-share)

[Lab 3: Blobfuse](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md#lab-3-blobfuse2)

[Lab 4: fstab options](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md#laboratory-4--fstab-options)



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

9.  Format the logical volume with xfs filesystem type, create an empty directory to mount the filesystem there, add the FSTAB entry, mount the volume and verify:

        mkfs.xfs <logical_volume_path>   #To format the logical volume
        mkdir <path_to_new_directory>    #Create an empty directory
        echo "<logical_volume_path>   <path_to_new_diretory>   xfs defaults,nofail 0 0" >> /etc/fstab  #To add the entry in fstab file
        mount <path_to_new_directory>  #To mount the filesystem
        df -Th |grep <name_of_new_diretory>  #To verify

    Example: 

![format](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/format.jpg)

10.  Create one file of size 1GB and verify the md5sum and note it down to check later after resize of disk, change the names if needed:

         dd if=/dev/zero of=/testdisk/myfile.dat bs=1024k count=1000
         md5sum /testdisk/myfile.dat

     Example:

![filecreation](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/filecreation.jpg)

11. Go to the Azure Portal, stop the VM named storagelab01 and resize the disk **datadisk0** from 4GB to 8GB.  Start the VM, connect to it, switch to root account and verify from OS level:

![diskresize1](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/diskresize1.jpg)

![diskresize2](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/diskresize2.jpg)

**Note** :In the previous example we can see the disk changed the name, now it's called /dev/sdc and the disk size got changed but still physical volume and filesyztem size will not be changed you can verify using the below commands: 

        pvdisplay /dev/sdc
        df -Th |grep testdisk

![verify2](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/verify2.jpg)
        
12.  Resize the physical volume and verify the size:

         pvresize <path_to_disk>
         vgdisplay <volume_group>

     Example:
     
![pvresize](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/pvresize.jpg)
     

13.  Extend the logical volume using 3GB and verify the size:

         lvextend -L +3G /dev/testvg/testlv
         lvs
         df -Th |grep test

     Example:

![lvresize](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/lvresize.jpg)

**Note:** We can see the logical volume size got change but still filesystem size will not be changed verify using below commands.   We need to extend the filesystem using **xfs_growfs** command for xfs filesystems and **resize2fs** for ext4 filesystems.

14.  Extend the filesystem using the below commands and verify the size and check the myfile.dat checksum for consistency:

         xfs_growfs /testdisk
         df -Th |grep test
         md5sum /testdisk/myfile.dat

Example: 

![fsresize](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/fsresize.jpg)


[Click here to return to Storage menu](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md)


### Scenario 2
#### Extend the existing disk and resize the LVM (In this case LVM is created on top of partitions of disk)

1. Create and attach a new empty disk of 4GB to the storagelab01 VM.
2. Identify the disk from OS perspective:

        lsblk

    Example:

![newdisk](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/newdisk.jpg)

3.  Create a partition using new disk following the below commands:

        fdisk <disk_path>  #in previous example that path will be /dev/sdd
        n #this will be proceeding to create a new partition
        p  #You can also just hit on "enter" instead of writing letter "p" this value will takes up the default value, which is primary partition.
        1  #In this step you can choose a partition number, it doesn't have to be number 1, but by default it chooses number 1, so you can hit also on enter or choose the number of your partition.
        2048  #This step is to determine the starting point for the partition, default will select the next available cylinder on the drive, hit on enter o type the first available number.
        8388607  #Here you can select the partition size, hit on enter to take the last value (using entire disk) or select the size you want for the partition for the lab we're using all disk.
        p  #this will print the partition table for this disk, created partition should appear here.
        w  #This letter will allow you to seve and exit fdisk command, changes will be permanent after this command is executed. 

Example: 

![newpartition](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/newpartition.jpg)

4. Run the **partprobe** comand to inform the OS of partition table changes:

       partprobe

5.  Change partition ID/Type for LVM:

        fdisk <disk_path>  #In previous example that path will be /dev/sdd
        t #toggle the partition ID, it will chose the one existing by default
        #You can press L here to check in all the available IDs or jump this step
        8e #To choose Linux LVM
        w #To save changes and exit
        fdisk -l <disk_path> #To verify the change

   Example: 

   ![partitiontype](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/partitiontype.jpg)

6. Create a second physical volume, volume group and logical volume and verify:

        pvcreate <path_to_partition>
        vgcreate <volume_group_name> <path_to_partition>
        lvcreate -l 100%FREE -n <logical_volume_name> <volume_group_name>
        pvs |grep <disk_name>
        vgs |grep <volume_group_name>
        lvs |grep <logical_volume_name>

   Example:

 ![lv2](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/lv2.jpg)


 7. Format the logical volume using xfs filesystem type and add the fstab entry, mount and verify:

        mkfs.xfs <logical_volume_path>
        mkdir <new_directory_path>
        echo "<logical_volume_path>  <mount_directory_path> xfs defaults,nofail 0 0" >> /etc/fstab
        mount -a
        df -Th|grep <new_directory_name>

Example: 

 ![format2](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/format2.jpg)

 
8.  Create one files of 1GB size and verify the md5sum and note it down to check later after resize of disk.

        dd if=/dev/zero of=<file_path_name> bs=1024k count=1000
        md5sum <file_path_name>

Example: 

 ![file2](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/file2.jpg)


9. Let us think our new filesystem is full and we need to extend the size of the disk.  Stop the VM and resize the second disk added from 4GB to 8 GB.   Start the VM and verify from OS level. 

        lsblk

 ![resize2](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/resize2.jpg)
 
 ![size2](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/size2.jpg)

 **Note:** We can change of size only in the disk and not in partition. We can delete and recreate the partition again.  Data on the disk will not be lost, only the partition mapping will be deleted and created again.

10. Delete and create a new partition from the resized disk:

        fdisk <disk_path>
        d #To delete the current partition.
        n #To create a new partition.
        p #To select primary, you can just hit on enter as p is choosen by default.
        1 #Select the partition number or just hit enter to select the default one.
        2048  #Select the starting point for the partition, default will select the next available cylinder on the drive, number should be the same than the one partition had as starting point.
        16777215 #Select the last point for the partition or just hit enter, again we're going to use entire disk.
        N #in question "Do you want to remove the signature? [Y]es/[N]o" answer No with a upper case N.
        p #to check on partition table, check on the partition size should be 8GB.
        w #to write the changes and exit.
        
Example: 

 ![resizepartition](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/resizepartition.jpg)

11.  Resize the physical volume and verify.   Then, extend the logical volume in 3GB and resize the filesystem. Check on md5sum of the file for consistency, value should be same:

         pvresize <physical_volume>
         pvs
         vgs
         lvextend -L +3GB <logical_volume>
         lvs
         xfs_growfs <filesystem>
         df -h <filesystem>
         md5sum <file_path>

Example: 

 ![secgrowth](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/secgrowth.jpg)


[Click here to return to Storage menu](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md)


### Scenario 3
#### Extend the existing disk and resize the LVM by creating new partitions

1. Stop the VM and resize the same second disk attached to it from 8GB to 16GB.   Start the VM, connect to it, switch to root account and check on it.
2. Identify the disk and create the second partition:

        lsblk
        fdisk <disk_path>
        n #To create the new partition
        p #select p or just hit on enter to select default, we're creating a primary partition.
        2 #Select partition number or just hit on enter to select the default number.  If you select manually, it needs to be different id from previously created partition.
        16777216 #Hit on enter to determine the starting point of the partition.  Default will select the next available cylinder on the drive.
        33554431  #Hit on enter to select all the available space in disk (remainin 8GB)
        w #To write the partition table changes and exit fdisk command.

Example: 

 ![resize3](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/resize3.jpg)


3. Run the partprobe command to scan the newly modified partition table and check:

        partprobe
        fdisk -l <disk_path>

Example: 

 ![partprobe](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/partprobe.jpg)

4.  Toggle the partition ID for LVM:

        fdisk <disk_path>
        t #Press t to toggle
        2 #Select the partition id you just created, if you choose  default one it will be number 2. You can also hit enter to choose default.
        8e #Type 8e to select the LVM id
        w #write the changes and exit the command
        fdisk -l <disk_path> #To check on the partition table and changes

Example: 

 ![toggle](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/toggle.jpg)


5.  Create a physical volume on the second partition.  Extend the volume group and resize the logical volume.  Grow the filesystem and check with following commands:

        pvcreate <second_partition_path>
        vgextend <volume_group> <second_partition_path>
        pvs #To check on the physical volumes
        vgs #To check on volume groups
        lvextend -L +8G <logical_volume>
        lvs #To check on logical volume
        xfs_growfs <filesystem>
        df -Th |grep <filesystem>
   
Example: 

 ![growth2](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/growth2.jpg)


[Click here to return to Storage menu](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md)



### Scenario 4
#### Extend the logical volume by adding new disk to the volume group

1. Create and attache an empty disk of 4GB to the VM. Identify it from operative system perspective with command:

        lsblk

Example, in this particular case, the added disk is called /dev/sde: 

  ![thirddisk](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/thirddisk.jpg)


2.  Create a new partition using entire disk as explained in Scenario 2, step 3.

Example: 

 ![part4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/part4.jpg)

3.  Create a new physical volume,extend volume group and check:

        pvcreate <partition_path>
        vgextend <volume_group_name> <partition_path>
        pvs
        vgs

Example: 

 ![extend](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/extend.jpg)

4. Extend the logical volume, resize the filesystem and check:

        lvextend -L +4G <logical_volume>
        xfs_growfs <filesystem>
        df -Th |grep <filesystem>
Example: 

 ![extend4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/extend4.jpg)

 **Note:**  Remember to delete all the resources once you have completed the Laboratories. 

 ### Your Goal 

 At the end of this lab, you should know how to: 

 - Resize an existen physical volume, volume group and logical volume.

LVM offers a great flexibility on doing hot resizes without the need to unmount anything. It is recommended you test more with LVM such as deleting volumes, adding a new disk, extending an existent volume group, or creating a new one, growing and shrinking, creating snapshots, etc.

### References

[Increasing the Size of an XFS File System](https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/storage_administration_guide/xfsgrow)

[How to extend a logical volume and its filesystem online in Red Hat Enterprise Linux?](https://access.redhat.com/solutions/24770)

[Linux LVM Cheat Sheet / Quick Reference](https://unixutils.com/lvm-cheat-sheet-quick-reference/)




[Click here to return to Storage menu](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md)



## Lab 2: Azure file share

### About this Lab

- This course/module was created for Storage Lab Azure file share
- It will take approximately 15 minutes
- This module introduces you to the tools needed to work with file share in Linux.
- This Lab provides hands-on activities.
- After this course/module you will be able to:
      - Create and configure file share to mount the share to the VM.

### Scenario
This laboratory is to create a file share and test the mounting on a Linux VM. We're going to use same VM than previous Laboratory. 

### Instructions

1. Using Azure Portal, go to the Resource group you created for the training.  Search for the storage account created with previous Laboratory, click on the storage account name.  Then click on the left pannel in "File shares"

 ![step1fileshare](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step1fileshare.jpg)

 2.  Click in "+File share" and create a file with name "testshare", you can compare the options in the following screenshot, click in "Create": 

![step2fileshare](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step2fileshare.jpg)

 3.  Using your preferred SSH client, connect to the Azure VM and switch to root account with command:

         sudo -i 

 4.  Proceed to install the prerequisite.  Ensure cifs-utils package is installed.  Follow the instructions provided in the following link, if necessary, change the tab so you use instructions for the correct Operative System:

        [Mount SMB Azure file share on Linux Prerequisites](https://learn.microsoft.com/en-us/azure/storage/files/storage-how-to-use-files-linux?tabs=RHEL%2Csmb311#prerequisites)

5. Go back to the Azure Portal, go to the file share and click in "Connect".  Then, proceed to select the Operative System "Linux" and finally click in "Show Script":

![step3fileshare](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step3fileshare.jpg)

6. Copy the infomation showed in the script.  Go back to the connection you made with the VM using SSH client and paste the commands in the prompt.


7.  Check you have the file share mounted and it's added to the fstab with the following commands:

        df -h |grep test
        grep test /etc/fstab
    
8.  Create a test file with name "file":

        touch /mnt/testshare/file
        ls -l /mnt/testshare/file

9.  Go to Azure Portal to the file share, click in "Browse" and verify the file is in place:

![step4fileshare](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step4fileshare.jpg)

### Your Goal
At the end of this lab, you should know ho to create a file share and configure it in a Linux VM. 

### References

[What is Azure Files?](https://learn.microsoft.com/en-us/azure/storage/files/storage-files-introduction)


[Click here to return to Storage menu](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md)



## Lab 3: BlobFuse2

### About this Lab

- This course/module was created to Storage Lab3 Blobfuse
- It will take approximately **30** minutes
- This module introduces you to the use of blobfuse.
- This Lab provides hands-on activities.
- After this course/module you will be able to:
      - Install and configure blobfuse to mount the container from blob storage using configuration file.

### Deployment instructions

1. Proceed to create a Red Hat 8.8 VM using the following button, if you want to deploy in a different tab, please use right-click. Also please remember to complete the empty spaces:

    [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fStorage%2fStorageLab3.json)

2. Once the VM is created, connect to it using SSH protocol, switch to root account and check on Linux version running following commands:

        sudo -i
        cat /etc/*-release

Example: 

 ![version](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/version.jpg)

   
3.  Download BlobFuse2 using Microsoft software repositories for Linux:

        rpm -Uvh https://packages.microsoft.com/config/rhel/8/packages-microsoft-prod.rpm

Example: 

  ![download](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/download.jpg)


4. Install the blobfuse2 package:

       dnf install blobfuse2 -y

Example: 

  ![install](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/install.jpg)

5. Create an empty directory to be used as mount point for the blob storage container:

        mkdir <directory_path>

Example: 

![mountpoint](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/mountpoint.jpg)


6. Go to Azure Portal, search for your Resource group and search for the storage account created.  Click on it and then click in left panel in "Containers".  Create a new Container with the name you prefer.

Example: 

![containers](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/containers.jpg)


7. In Azure VM, create a YAML configuration file to be used to mount the blobfuse, in the example we created under /etc directory, the file should contain the following information:

        allow-other: true

        logging:
          type: syslog
          level: log_debug

        components:
          - libfuse
          - file_cache
          - attr_cache
          - azstorage

        libfuse:
          attribute-expiration-sec: 120
          entry-expiration-sec: 120
          negative-entry-expiration-sec: 240

        file_cache:
          path: <temporary_directory_that_will_be_used_by_blobfuse>
          timeout-sec: 120
          max-size-mb: 4096

        attr_cache:
          timeout-sec: 7200

        azstorage:
          type: block
          account-name: <your_storage_account_name>
          account-key: '<your_storage_account_key>' #Check on the note below
          endpoint: https://<your_storage_account_name>.blob.core.windows.net
          mode: key
          container: <container_name>

 **Note:**  You can get your account-key from Azure Portal, in the Storage Account, select "Access keys" from left panel and then click in "Show" to copy from there.

![key](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/key.jpg)


Example: 

![file](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/file.jpg)


8.  Mount the blobfuse in the directory created with command:

         blobfuse2 mount <directory_name> --config-file=<configuration_file>

Example: 

![mount](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/mount.jpg)

### References

[What is BlobFuse?](https://learn.microsoft.com/en-us/azure/storage/blobs/blobfuse2-what-is)

[How to mount an Azure Blob Storage container on Linux with BlobFuse2](https://learn.microsoft.com/en-us/azure/storage/blobs/blobfuse2-how-to-deploy?tabs=RHEL)

[BaseConfig.yaml](https://github.com/Azure/azure-storage-fuse/blob/main/setup/baseConfig.yaml)



[Click here to return to Storage menu](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md)


## Laboratory 4:  fstab options

### About this Lab

- This course/module was created to show fstab file options
- It will take approximately 30 minutes
- This Lab provides hands-on activities.
- After this course/module you will be able to:
      - Verify the mount options in /etc/fstab file and know how it will impact the Operative System. 

### Instructions

1.  For this laboratory we are going to use the same VM than previous laboratory.   Please proceed to connect to the VM using the SSH client you prefer, switch to root account and review the list of block devices attached to it with command:

        sudo -i
        lsblk

2.  Go to Azure Portal, create and attach a 4GB data disk.
   
3.  Return to the SSH connection and list the block devices attached to the VM, identify the new disk:

        lsblk

4.  Create a partition on the attached disk using all the space in following example we are using /dev/sdc as the newly attached disk, please replace the information with the correct one for your case:

        fdisk <disk_path>  
        n #this will be creating a new partition
        p  #You can also just hit on "enter" instead of writing letter "p" this value will takes up the default value, which is primary partition.
        1  #In this step you can choose a partition number, it doesn't have to be number 1, but by default it chooses number 1, so you can hit also on enter or choose the number of your partition.
        2048  #This step is to determine the starting point for the partition, default will select the next available cylinder on the drive, hit on enter o type the first available number.
        8388607  #Here you can select the partition size, hit on enter to take the last value (using entire disk) or select the size you want for the partition for the lab we're using all disk.
        p  #this will print the partition table for this disk, created partition should appear here.
        w  #This letter will allow you to seve and exit fdisk command, changes will be permanent after this command is executed. 

    ![step1lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step1lab4.jpg)
   
5.  Run the **partprobe** command to scan the newly modified partition table and verify with the below commands:

        cat /proc/partitions
        fdisk -l
        lsblk |grep <partition_name>

    ![step2lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step2lab4.jpg)

6.   Format created parition with XFS filesystem type.

         mkfs.xfg <partition_path>

     ![step3lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step3lab4.jpg)
    
7.  Create an empty directory to be used as mount point:

        mkdir <new_directory_path>

    ![step4lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step4lab4.jpg)
    

8.  Get the UUID of the partition, add the entry in fstab file using the read-only(ro) option, mount it and check:

        blkid <partition_path>
        echo "UUID=<UUID>   <mount_directory_path>   xfs   defaults,ro  0 0" >> /etc/fstab
        mount -a
        df -Th|grep <mount_point>

    ![step5lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step5lab4.jpg)

9.  Go to the mounted directory and create an empty file:

         cd <mounted_directory>
         touch <file_name>

     ![step6lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step6lab4.jpg) 

**Note:** As you can see the filesystem is read-only so you cannot modify it.  Read-write options will come by defaults for the local disk, so no need to specify in the fstab or mount options. For the remote filesystems we need to explicitly specify the read-write option.

10.  Let's try with the NOEXEC option, which will not allow user to execute anything on the filesystem.   Proceed to umount the filesystem we just created, modify the _/etc/fstab_ file in the device line, changing the read-only(ro) option by "noexec" option and mount the filesystem again:

         cd / #To move out of the filesystem
         umount <directory>
         vi /etc/fstab   #inside change the options and save the file
         cat /etc/fstab |grep <directory> #to verify the changes
         mount -a
         df -Th |grep <directory>

     ![step7lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step7lab4.jpg) 

11.  Create a new file and add the contents below following these commands, replace the directory name below:

         cat <<EOF > <directory>/file1.sh
         #!/bin/bash
         mkdir <directory>/testdir
         EOF
     ![step8lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step8lab4.jpg)

12. Provide execute permissions to the file and try to execute it:

        chmod +x <directory>/file1.sh
        <directory>/file1.sh

     ![step9lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step9lab4.jpg)

13.  Umount the filesystem, remove the "noexec" option, mount the filesystem back and try to execute the script again:

         umount <directory>
         vi /etc/fstab #inside remove the noexec option and save the file
         cat /etc/fstab |grep <directory> #to verify the changes
         mount -a
         cd <directory>
         ./file1.sh

     ![step10lab4](https://github.com/mitchcr/ONEVM/blob/main/Storage/images/step10lab4.jpg)

**NOSUID Option**

Filesystems mounted with the nosuid option do not allow set-user-identifier (SUID) or set-group-identifier (SGID) bits to take effect. In other words, even if an executable file has the SUID bit set, it will not be executed as the file's owner, instead it will execute with the privileges of user who is executing.

**Example files>**

        /bin/passwd
        /bin/su
        /usr/bin/mount 

#### Your goal
At the end of this lab, you should know how to:
- Use the mount point options in the _fstab_ file and how it will impact on the operative system level.

#### References 
[Filesystem table (/etc/fstab) Cheatsheet](https://dcjtech.info/wp-content/uploads/2016/06/Filesystem-Table-etc-fstab-Cheatsheet.pdf)



[Click here to return to Storage menu](https://github.com/mitchcr/ONEVM/blob/main/Storage/readme.md)

#### Return to the [Main Menu](https://github.com/mitchcr/ONEVM/blob/main/readme.md)

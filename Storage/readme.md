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

<a href="https://raw.githubusercontent.com/mitchcr/ONEVM/main/Storage/StorageLab01.json" target="_blank">
<img src="https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png"/>
</a>

2.  

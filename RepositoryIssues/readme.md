# Repository Issues Laboratory

## About this Lab
- This course/module was created to Repository Issues Module.
- It will take approximately 60 minutes.
- This module introduces you to Repository Issues.
- This Lab provides hands-on activities.
- After this course/module you will be able to:
  - Disable/Enable EUS repository
  - Fix certificate issues

## Lab 1:  Fix VM created using EUS repo, unable to update the VM to latest version

### Instructions

1.  Using WSL set your subscription id(change _<YOUR_SUBSCRIPTION_ID_HERE>_ for your susbcription id):

         az account set --subscription <YOUR_SUBSCRIPTION_ID_HERE>

2.  Create a resource group named repository in _eastus_ location:

        az group create -l eastus -n repository

3.  Create a Red Hat VM using below command, change _<TYPE_A_PASSWORD_HERE>_ for a password of your election:

        az vm create --resource-group repository --name repository-lab1 --image "RedHat:RHEL:7.6:7.6.2019062116" --admin-username azureuser --admin-password <TYPE_A_PASSWORD_HERE> --location eastus

### Task

Update the VM from Red Hat 7.6 version to the latest version. 

### Solution

          rpm -qa| grep -i rhui

As per the output the VM is having EUS repositories in it.

We need to disable the EUS repositories and enable tne non-EUS repositories using the link [Switch a RHEL 7.x VM back to non-EUS (remove a version lock)](https://learn.microsoft.com/en-us/azure/virtual-machines/workloads/redhat/redhat-rhui#switch-a-rhel-7x-vm-back-to-non-eus-remove-a-version-lock)

Post which you should be able to update the VM.

In case if you need to switch back to the EUS repositories, please follow the following document [Red Hat Update Infrastructure for on-demand Red Hat Enterprise Linux VMs in Azure](https://learn.microsoft.com/en-us/azure/virtual-machines/workloads/redhat/redhat-rhui#switch-a-rhel-vm-7x-to-eus-version-lock-to-a-specific-minor-version)

## Lab 2: VM update

### Instructions

1.  Using WSL create a Red Hat VM using below command, change _<TYPE_A_PASSWORD_HERE>_ for a password of your election:

        az vm create --resource-group repository --name repository-lab2 --image "RedHat:RHEL:7-LVM:7.6.2018103108" --admin-username azureuser --admin-password <TYPE_A_PASSWORD_HERE> --location eastus

### Task

Update the VM from Red Hat 7.6 version to the latest version. 

### Solution 

      rpm -qa| grep -i rhui
      openssl x509 -in /etc/pki/rhui/product/content.crt -noout -text | grep -E 'Not Before|Not After'

From the output of above 2 commands, we could see that the VM is having the right repositories (non-EUS), but the problem is the certificate which is already expired in 2018 itself.  To overcome the certificate issue, we need to run the below command to download the latest version of RHUI rpm: 

**Note:** This command will only download the rhui rpm alone.   It wold not update the VM to the latests patches. 

## Lab 3: VM update with a Load Balancer in place

### Instructions

      



# Stakeholders of a SSH Connection Lab

### About this Lab
- This course/module was created for the module Stakeholders of a SSH connection.
- It will take approximately 60 minutes.
- This module introduces you to Stakeholders of a SSH connection.
- This Lab provides hands-on activities.
- After this course/module you will be able to:
    1. Locate an issue at service level.
    2. Understand why routing informationis required and how to alter it
    3. Create simple iptables rules and understand their order

 ## Lab 1

 1. Deploy an Ubuntu 18.04 VM using the link below, it will be asking for a password for the user "azureuser": 

    [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fStakeholdersOfASSHConnection%2flab1StakeHoldersUbuntu.json)

2. Deploy a Red Hat VM using the link below, it will be asking for a password for the user "azureuser": 

    [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fStakeholdersOfASSHConnection%2flab1StakeHoldersRHEL.json)

### Task

Try to log in to these 2 VMs.  Find out what could be the reason you cannot connect. 

## Lab 2

 1. Deploy an Red Hat VM using the link below, it will be asking for a password for the user "azureuser": 

    [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fStakeholdersOfASSHConnection%2flab2StakeHolders.json)

After deploying the VM, the access to the VM using SSH protocol is list and it is required to use Serial Console. 

### Task 

1. Connect to the Serial Console using "azureuser" account and the password provided during the VM deployment.   Switch to root account and get the routing-table information.  You'll see there is no information available.
2. To get access to the internet and the datacenter add the missing route information manuall to the VM.  Use *ip route* to do this.

The missing routes are:

- Host: 168.63.129.16
- Host: 169.254.169.254
- default-route
- The default network each VM is part of needs to be added to the OS as well, use “ip add” to see what network is assigned to the interface or get the info from ASC e.g., 10.240.0.0/16
- Keep an eye on the default route. If this is missing what does happen?  Remove the route again if required.

  



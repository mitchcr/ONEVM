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

  
## Lab 3

## Instructions

 1. Deploy an Red Hat VM using the link below, it will be asking for a password for the user "azureuser": 

    [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fStakeholdersOfASSHConnection%2flab3StakeHolders.json)

iptables services are not installed by default on recent versions of Red Hat, so during the deployment you created a Red Hat VM and we stopped and maske firewalld and installed and started iptables services for you. 

## Task

1.  Connect to the VM's Serial Console and switch to root account.
2.  Create a drop rule for SSH to block incoming trafic:

        iptables -A INPUT -p tcp --dport 22 -j DROP

    Are you able to logon via SSH to the VM? if yes, restart the sshd service and try again.

3. Create a rule to drop incoming traffic for all but your address, to do that, you need to know your current IP address, use the following site to get the information [What is My IP?](https://www.whatismyip.com/). Change <YOUR_IP_ADDRESS> with this information in the following command: 

        iptables -A INPUT -p tcp --dport 22 -s <YOUR_IP_ADDRESS> -j ACCEPT

    After adding this new rule are you now able to log on via SSH?

4.  Although you have added a rule to accept traffic from your IP, you are bloked.  Why?
   
       The reason is the order of the rules.  Use the following command to see the rules applied and ruleset-number:

        iptables -L -n -v --line-numbers

5.  Delete a rule.   To get access to the VM again the first rule must be deleted.  Use the following command to get the ruleset-number of the DROP rule from step 2:

        iptables -L --line-numbers

    Now, delete the rule:

        iptables -D INPUT <RULE_NUMBER>

    Access to the VM is possible after this step.

6.  List all the rules.  To see what rules are active on the VM you can use the following command:

        iptables -L

    By default, the filter table is displayed.  To see a different table, use the option _-t_, and the table name.   The tables are:
    - filter
    - nat
    - mangle
    - security

7.  To flush (disable) all rules use this command:

        iptables -F

    By default, the filter table is flushed only.   We have rules in the security table.  Please remove them.




#### Return to the [Main Menu](https://github.com/mitchcr/ONEVM/blob/main/readme.md)

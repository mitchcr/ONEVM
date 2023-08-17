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

      sudo yum update -y --disablerepo='*' --enablerepo='*microsoft*'

**Note:** This command will only download the rhui rpm alone.   It wold not update the VM to the latests patches. 

## Lab 3: VM update with a Load Balancer in place

### Instructions

1.  Using WSL create a Red Hat VM using below command, change _<TYPE_A_PASSWORD_HERE>_ for a password of your election:

        az vm create --resource-group repository --name repository-lab3 --image "RedHat:RHEL:7-LVM:7.9.2020100116" --admin-username azureuser --admin-password <TYPE_A_PASSWORD_HERE> --public-ip-address "" --vnet-name repository --subnet primary --location eastus

3.  Create a Standard Internal Load Balancer and other components of SILB using below set of commands:

        az network lb create --resource-group repository --name labloadbalancer --sku Standard --vnet-name repository --subnet primary --frontend-ip-name labfrontend --backend-pool-name labbackendpool --location eastus
        

5.  Create a load balancer health probe using below command:

        az network lb probe create --resource-group repository --lb-name labloadbalancer --name labhealthprobe --protocol tcp --port 443

7.  Create a load balancer rule using below commands:

        az network lb rule create --resource-group repository --lb-name labloadbalancer --name labrule --protocol tcp --frontend-port 443 --backend-port 443 --frontend-ip-name labfrontend --backend-pool-name labbackendpool --probe-name labhealthprobe --idle-timeout 15    
        az network nic ip-config address-pool add --address-pool labbackendpool --ip-config-name ipconfigrepository-lab3 --nic-name repository-lab3VMNic --resource-group repository --lb-name labloadbalancer

### Task

Make sure there are no pending updates in the VM. 

### Solution

When you have an Azure VM hosted behind a Standard Internal Load Balancer, the Azure VM will not be able to communicate to the internet, unless the load balancer is external facing, or if the Azure VM is associated to a Public IP of standard SKU. 

**You can refer to Scenario 2 from here**  [Load balancer outbound connections](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections#2-associate-a-nat-gateway-to-the-subnet)  You can find more information on how to [create a NAT gateway and associate it with an existing subnet](https://learn.microsoft.com/en-us/azure/nat-gateway/manage-nat-gateway?tabs=manage-nat-cli#create-a-nat-gateway-and-associate-it-with-an-existing-subnet)

#### Next action plan 

These public IP addresses must be attached directly to the VM on the Network Interface. However you can filter the traffic for the VM for security reasons using Network Security Groups. 

Please refer to the following article for why a load balancing rule is required for Internet access when using a Standard external load balancer:  [Load Balancer outbound connections](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections#lb) 

_"In a scenario, where the VM is part of a public Load Balancer backend pool. The VM does not have a public IP address assigned to it. The Load Balancer resource must be configured with a load balancer rule to create a link between the public IP frontend with the backend pool. It is not necessary for the rule to have a working listener in the backend pool for the health probe to succeed. When the load-balanced VM creates an outbound flow, Azure translates the private source IP address of the outbound flow to the public IP address of the public Load Balancer frontend. Azure uses SNAT to perform this function.”_

- Perform an update on the VM using below command:

      yum update -y 

## Lab 4

### Instructions

1. Deploy a SuSE VM using the link below, it will be asking for your public ssh key, be ready to provide it.

    [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fRepositoryIssues%2fRepositoryIssuesLab4.json)


2. Check if the VM is registered running the following command as root account:

        SUSEConnect -s 

      The command should tell you the VM is _Not Registered_

### Task

Make sure SUSEConnect -s should show as Registered and update the VM to the latest patches in current version.

### Solution

1.  Connect to the repository-lab04 VM and switch to root account.
2.  Check the output of the following command: 

        tail -n 100 /var/log/cloudregister

We could see that the baseproduct link is wronly  mapped.   

To fix follow these commands: 

3. Change to the /etc/products.d directory:

        cd /etc/products.d

4. Remove the current link:

        unlink baseproduct

5. Create the correct link:

        ln -s SLES.prod baseproduct
   
6. Verify if the link is rightly mapped or not:

        ls -lh

7. Re-register the VM:

        registercloudguest --force-new

8.  Verify if the VM is registered or not:

        SUSEConnect -s
  


#### Return to the [Main Menu](https://github.com/mitchcr/ONEVM/blob/main/readme.md)

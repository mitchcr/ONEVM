# Let's start with Specialist training!

During this training we're going to work in a series of Linux laboratories that will be helping you to understand the covered topics and also will teach you on proper troubleshooting skills. 

## Step 1: WSL2
To start we need work with WSL2, if you have it installed jump to Step 2.  If you don't have it installed please make sure your desktop meets the required requirements to install WSL2: 
- Have the possibility to run PowerShell with Administrator privileges.
- Windows 10, version 2004 or higher or Windows 11.
- A computer that supports Hyper-V virtualization.
- The latest instructions and details are located at [Install Linux on Windows with WSL](https://learn.microsoft.com/en-us/windows/wsl/install)

If your computer passed all the requirements, open a PowerShell window with Administrator rights and run the following command: 

`wsl --install`

**Note:**  This can take up some time depending on your bandwidth access and computer resources.   REBOOT the computer once the second finishes. 

## Step 2: Windows Terminal
Download and Install Windows Terminal, if you already have it please jump to Step 3.  To download and install Windows Terminal use the following URL: [Windows Terminal](https://aka.ms/terminal)

## Step 3: Install the Azure CLI package
Launch Windows Terminal and click on the pull-down menu. 
![Windows Terminal drop-down menu](https://github.com/mitchcr/ONEVM/blob/main/WSL/images/WindowsTerminal1.png)
![Windows Terminal OS selection](https://github.com/mitchcr/ONEVM/blob/main/WSL/images/WindowsTerminal2.png)

Select the Linux distribution recently installed. 

- Update to the latest available packages
- Download and install the Microsoft signing key
- Add the Azure CLI software repository

Update repository information and install the azure-cli package: 

`sudo apt-get update`

`sudo apt-get install ca-certificates curl apt-transport-https lsb-release gnupg`

Download and install the Microsoft signing key:

`curl -sL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor |sudo tee /etc/apt/trusted.gpg.d/microsoft.gpg > /dev/null`

Add the Azure CLI software repository: 

`AZ_REPO=$(lsb_release -cs)`

`echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" | sudo tee /etc/apt/sources.list.d/azure-cli.list`

Update repository information and install the azure-cli package: 

`sudo apt-get update`

`sudo apt-get install azure-cli`

## Step 4: Working with the Azure CLI

Login to Azure Portal using your work login credentials. 

`az login`

Get a list of available accounts and isDefault attribute in table format:

`az account list --query "[].{Name:name, Id:id, IsDefault:isDefault}" -o table`

`az account set --subscription <SUBSCRIPTION__ID>` 

Get a list of available resource-groups active on the default subscription: 

`az group list --query "[].name" -o table`

Get help with a particular topic: 

`az group --help`

`az group create --help`

Create a resource group and a virtual machine running Ubuntu: 

__Note__: Replace the home directory \<YOURUSERID\> with your own when you list the generate keys. 

`az group create --name specialist --location eastus`

`az vm create --resource-group specialist --name specialistvm1 --admin-user azureuser --image UbuntuLTS --location eastus --generate-ssh-keys`

__SSH key files are generated and located in /home/\<YOURUSERID\>/.ssh/id_rsa and /home/\<YOURUSERID\>/.ssh/id_rsa.pub second file is the public key.  If you're using a machine without permanent storage, back up your keys to a safe location.__

At the end of the Azure CLI command to create the VM you'll get the VM IP address. Before connecting, let's check on the SSH keys generated: 

`ls -ld /home/<YOURUSERID>/.ssh/id*`

You should see in the output 2 entries one for id_rsa and another for id_rsa.pub.  Now let's connect to the VM using the IP address provided in the output of az vm create command: 

`ssh azureuser@<IP_ADDRESS>`

Install a Virtual Machine specifying a particular SKU code and using same keys we generated previously: 

`az vm create --resource-group specialist --name specialistvm2 --admin-user azureuser --image 'RedHat:RHEL:7-RAW:7.7.2019090418' --location eastus --ssh-key-values ~/.ssh/id_rsa.pub`


## Your Goal
At the end of this lab, you should know how to: 
- Install and configure the Windows System for Linux
- Install and configure Ubuntu 20.04 LTS for Windows app
- Install and configure the Windows Terminal app.
- Install and configure the Azure CLI in WSL2 environment.
- Create virtual machines and interact with them via the Azure CLI.

## References
[Install the Azure CLI for Linux Manuall | Microsoft Docs](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux?pivots=apt)

[Use the Azure CLI to create a Linux VM | Microsoft Docs](https://learn.microsoft.com/en-us/azure/virtual-machines/linux/quick-create-cli)

[JMESPath](https://jmespath.org/)


#### Return to the [Main Menu](https://github.com/mitchcr/ONEVM/blob/main/readme.md)

# VM Recover Lab

## About this Lab

- This course/module was created to VM Recover LAB
- It will take aproximately 60 minutes.
- This module introduces you to the tools to VM Recover.
- This Lab provides handos-on activities.
- After this course/module you will be able to recover a Linux configuration file using the sed tool.

## Lab 1: Corruption of the sshd_config file
### Scenario
In this scenario your customer may have upgraded a VM, installed new software or has accidentaly _mangled_ the sshd_config file.  Upon restarting the sshd daemon no new sshd connections can be established with the VM. You need to remove the offending lines. 

### Deployment instructions

1. Deploy an Ubuntu 20.04 VM using the link below, it will be asking for your public ssh key, be ready to provide it.

  [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fVMRecover%2VMRecoverLab1.json)

2. Once the VM

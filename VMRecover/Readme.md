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

    [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fVMRecover%2fVMRecoverLab1.json)

2. Once the VM is created, try to connect using SSH protocol.
3. There are various methods to recover this scenario. In this instance we are going to add an additional Linux user to the system and access the Serial Console.
   
_Question:_ Why do you think it's not possible to access the serial console with your existing azureadmin user?
  
_Answer:_ You have passwordless login, hence are not able to supply a private key certificate via the Serial console.   Adding a new Linux user with password and super user privileges will allow you to gain shell acess.   Please proceed to add a new account using the "Reset password" option in Azure Portal and provide a password for this new account.

5. Proceed to connect to the VM using the Serial Console and the user you created.
6. Once connected via that console verify the status of the SSH daemon

           sudo -i #to switch to root account
   
           systemctl status sshd

7. You can see the service has failed to start.   Try restarting it using: 

        systemctl restart sshd

8. Check the status of the service again:

           systemctl status sshd

9.  As it continues failing, now let's go and check on the contents of the configuration file:

           /etc/ssh/sshd_config

10.  As you see, there is 1 erroneous line at the very end of the file, this text is causing the SSHD to fail when being restarted.
11.  The SSHD binary has a "-t" option that will test the integrity of its configuration file.  Run the command to verify:
    
            sshd -t

You should see the configuration errors. 

12. The configuration file can be corrected using various Linux tools with editors such as:  **vi, vim, nano** or file manipulation commands, for example: **sed, awk, nawk**
13. Use your favorite to remove the problematic line in sshd configuration file.
14. Verify you removed the line:

        cat /etc/ssh/sshd_config
        sshd -t

15. Once the file has been corrected restart and verify the SSH service:

        systemctl restart sshd
        systemctl status sshd

16. List the daemon process using _ps_ command:

        ps -eaf |grep -i sshd

17.  Check it is listening for new connections:

            ss -tupln|grep -i ssh

18. Ensure you are stil _root_; you can check using the comand _id_

        id
    
20. Track the SSH connection requests using the following command:

        tail -f /var/log/auth.log
    
22. Use a SSH client tool, such as _putty_ or _WSL_ to connect to this VM.

    
24. Check back in the Serial Console, the log file you are tailing in the Serial Console will show the connect and eventual disconnect messages, in this particular case we will not have any new lines (this is expected).  Press _Control+C_ to interrupt.  The service is currently up and running, but the SSH connections are still failing.  These scenarios occur in real life where is not just one thing that could be happening.  In Lab2, we'll continue the troubleshooting to finish fixing current scenario. 

### Your goal 
Let's summarize what you ahve learned after this lab: 
- Add a new local Linux user using the portal as our original account is passwordless.
- Verify the integrity of the sshd_config file using _sshd -t_.
- Delete erroneous entries in the sshd_config file.
- Manage the SSH daemon process using _systemctl_.
- Verify the daemon process using _ps, ss_.

## Lab 2: Run command to reset sshd_config default port
- The time to complete this lab is 30 minutes.
- After this lab you will be able to recover a Linux configuration file using _sed_ tool.

### Scenario
In this scenario your customer may have changed the SSH default port and restarted the sshd service.  Now other users are unable to login.   You have to modify the sshd configuration file to set the port to default (22) through "run command" from the portal. 

### Deployment instructions

For this lab we'll continue using the VM created previously as connections using SSH are currently not available using port 22. 

1.  To start troubleshooting the issue you can verify the service status. 

        systemctl status sshd

2.  Checking on the output of that command you can see the port is different that the default one (22), if you're not able to see it in the logs you can also check with command:

        journalctl -u sshd

3.   Another way to check on current listening port is filtering the configuration file and check directly in the port.   If the Port line starts with # symbol that means the VM is using default port to listen, which is 22.

    grep -i port /etc/ssh/sshd_config

4.  To fix the issue, go to the Azure Portal, select the VM.  Then, go to "Run command", select "RunShellScript" and add the below two commands to the "Linux Shell Script" section:

        sed -i 's/Port 2222/Port 22/g' /etc/ssh/sshd_config
        sshd -t
        systemctl restart sshd
    
6.  Select "Run" and wait until the execution is done, you'll get an output.  Check on it, the standard output(stdout) and standard error (stderr) should be empty.
   
7. Try to loging to the VM using an SSH client and port 22 and verify now you can access to it.
   
8.  Check the status of the sshd service with the following commands:

        systemctl status sshd
        journalctl -u sshd
        ss -tulpn |grep sshd

### Your goal
Let's summarize what you have learned after this lab: 
- Run Linux command using the "run command" feature on the portal.
- Verify the integrity of the sshd_config file using _sshd -t_ command.
- Change the port to default in the sshd_config file using _sed_ command.
- Manage the SSH daemon process using _systemctl_ command.
- Verify the daemon process using _ss_ command.

## Lab 3: Recover failed VM due to fstab error with the help of _vm repair_ extension
- The time to complete this lab is 60 minutes.

### Scenario
A VM may have stopped booting due to errors in the _/etc/fstab_ file or because the customer is using the scsi device name such as _/dev/sdc1_.  The scsi device name could get remapped to a different device.  This is not Azure functionality but is how SCSI standard functions. 

Best practice is to utilize the UUID when mounting additional data disks or RAID volumes as this will guarantee the correct underlying disks are mounted. 

### Deployment instructions

1. Deploy a SuSE VM using the link below, it will be asking for your public ssh key, be ready to provide it.

    [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fVMRecover%2fVMRecoverLab3.json)

3. Once the VM is created, confirm in the Serial Console and Serial log in Boot Diagnostics, you are in a non-boot scenario.  Check in the logs and identify the error.

4.  Using WSL or Cloud Shell proceed to install the _vm repair_ extension:

        az extension add --name vm-repair

5. Create a repair vm using the extension:

        az vm repair create -g <resource_group_name_of_failing_vm> -n <failed_vm_name> --repair-username <temporary_username> --repair-password <temporary_password> --verbose

Replace the information betwen <> accordily. 

6. At the end of the command execution you will have the Repair VM name, please proceed to connect to it using the username and password selected.

7. Switch to root account using command:

        sudo -i

8. Proceed to identify the data disk, as it is the copy of the damage OS disk and the one we need to fix.  You can do that using commands:

        dmesg

   or

        tail -10 /var/log/kern.log

   the disk will be the last attached to the OS disk.   Another way to check is with the command:

        lsblk

   Identify the disks using _TYPE_ column, then check which is the disk that doesn't have _/_ mounted, that will be your disk.

9.  Proceed to identify the root partition, that will be the one that has bigger size in the data disk.
10. Create an empty directory using command:

         mkdir /rescue

11. Proceed to mount the OS partition with command:

          mount <partition> /rescue

      for example: _mount /dev/sdc1 /rescue_  remember to mount the correct partition, the partition name and number can change.

12. Edit the _/repair/etc/fstab_ file and choose your preferred option to fix the issue:
- removing the problematic lines.
- commenting out the problematic lines adding a # symbol at the beginning of them.
- adding the option nofail in the problematic lines.

13.  Save the file, and double check you made the changes needed.

14.  Proceed to umount the filesystem with command:

         umount /rescue

15.  Swap the OS disk in the damage VM and delete the repair VM using the extension:

         az vm repair restore -g <resource_group_name_of_failing_vm> -n <failed_vm_name> --verbose

16. Check the VM now has a boot scenario.

###  Recover from the serial console

17.  Using Serial Console connect to the Lab VM and execute the following commands:

         echo "UUID=4ed50c8a-125c-4a9d-8ef0-846b40492f53  /datadrive   ext4   defaults,nofail   1   2"
         reboot

18.  Check you have a non-boot scenario in place.
19.  From Serial Console Log screen in Azure Portal, proceed to restart the VM and stop the boot process pressing key _ESC_
20.  In the Grub Menu, proceed to edit the first line pressing letter _e_, it will allow you to edit the selected kernel, first line is the default one.
21.  Scroll down in the file and search for the line that starts with "linux" add the following at the end of the line:

         init=/bin/bash

22. Press _Ctrl+x_ to save changes and boot the operative system.  It will stop in single-user mode.
23. At this moment you have access to the system but it's read-only access, so change to read-write using the command:

        mount -o remount,rw /

24.  Now you can edit the file _/etc_fstab_ and fix the issue as you did previously in the repair vm.
25.  Save the changes and check you made them.
26.  Reboot the VM.

Utilizing the serial-console is the preferred way to fix simple non-boot scenario. The help of a recovery VM is always required if there is no access to the serial-console or recovery-steps require a full working environment.

### Your goal
You should know how to resolve incorrect entries in the /etc/fstab by:
- Identifying through serial log / boot diagnostics when a drive is not being mounted.
- Using the VM serial console to easily fix the fstab file.
- Using the vm repair extension to automatically create a rescue VM and attach the faulty OS disk as a data disk.
- Using the kernel parmater 'init' with the value '/bin/bash' to boot into the system without a password.
- Correcting or commenting out from /etc/fstab the offending entry or entries.

### Reference
[Repair a Linux VM by using the Azure Virtual Machine repair commands - Virtual Machines | Microsoft Docs](https://learn.microsoft.com/en-us/troubleshoot/azure/virtual-machines/repair-linux-vm-using-azure-virtual-machine-repair-commands)


### Lab 4: Recover failed VM due to corrupt initrd with 'ALAR' scripts

- The time to complete this lab is 30 minutes.
- After this lab you will be able to recover a non boot-scenario with the help of the ALAR

### Scenario
In this scenario your customer may have installed the new kernel or patched the VM and rebooted it.   Now, the VM stuck in boot due to corrupt or missing initrd.   You have to use ALAR scripts to regenerate initrd/initramfs image file and reboot the VM to make it available. 

### Deployment instructions

1. Deploy an Ubuntu 20.04 VM using the link below, it will be asking for your public ssh key, be ready to provide it.

    [![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fVMRecover%2fVMRecoverLab4.json)

2. Once the VM is created, check the non-boot scenario, the VM will stuck on boot due to initrd issue and a kernel panic will be showed in the Serial Console. Analyze the error.
3. Using WSL or Cloud Shell fix the issue executing the following commands, remember to replace the information like resource group with the correct one:

       az vm repair create --resource-group "<resource_group_of_failed_vm>" --name "<Failed_VM_Name>" --verbose --repair-username "<temporary_usename>" --repair-password "<password>"
       az vm repair run --verbose --resource-group "<resource_group_of_failed_vm>" --name "<Failed_VM_Name>" --run-id linux-alar-fki --parameters initrd --run-on-repair
       az vm repair restore --verbose --resource-group "<resource_group_of_failed_vm>" --name "<Failed_VM_Name>"

4. Verify the VM is in a boot scenario.

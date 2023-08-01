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

    
24. Check back in the Serial Console, the log file you are tailing in the Serial Console will show the connect and eventual disconnect messages.  You can press _Control+C_ to interrupt.

### Your goal 
Let's summarize what you ahve learned after this lab: 
- Add a new local Linux user using the portal as our original account is passwordless.
- Verify the integrity of the sshd_config file using _sshd -t_.
- Delete erroneous entries in the sshd_config file.
- Manage the SSH daemon process using _systemctl_.
- Verify the daemon process using _ps, ss_.






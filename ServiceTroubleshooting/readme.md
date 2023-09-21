# Service Troubleshooting 

### About this Lab

- This lab was created for Azure Linux Academy Specialist
- It will take approximately ninety(90) minutes.
- This lab has two activities:
      - A troubleshooting activity to exercise break-fix work on systemd-based services.
      - A productive activity to practice systemd unit creation.

## Lab 1 : Service Troubleshooting

Duration 30~45 minutes. If you do not make significant progress in 15 minutes, please contact your instructor for hints. 

### Instructions

1. Deploy one RHEL VM using the link below:

[![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fServiceTroubleshooting%2fservice-lab1.json)

2. Confirm you can connect to the VM using Serial Console.

3. Try to connect to the VM using SSH protocol with any client you prefer.   You'll find it is not working.
  
4. At this point, the VM is broken.  Your objective is to troubleshoot and fix whatever is broken.


## Lab 2: Unit Production

Duration 30~45 minutes.  If you do not finish thi excersise in time, please let your instructor know.

### Instructions

>  In this exercise you will deploy a VM based on a systemd managed OS, you can proceed with the following link and choose the Linux flavor you want:


>  A web server needs to be run on port 8080 for only five minutes every hour.  This should be set up without using cron.
   
> You can use this python line to run a simple web server:

            /usr/bin/python3 -m http.server 8080

> Share your solution with the class. 

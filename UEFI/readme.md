### UEFI Module Lab

## About this Lab

- This course/module was created to Recreate an UEFI partition.
- It will take approximately 15 minutes.
- This module introduces you to the tools to Recreate an UEFI partition.
- This Lab provides hands-on activities.
- After this course/module you will be able to fix a boot issue due to a missing or corrupt UEFI boot-partition.

## Scenario

On this LAB the idea is to simulate that the UEFI partition was removed by mistake, and we need to recover it because the VM is not booting anymore. (Getting HANG). 

1. Proceed to create the VM clicking in the following button: 

[![Click to deploy](https://user-images.githubusercontent.com/129801457/229645043-e2349c38-7efd-4336-83c4-dab6897f9a7c.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3a%2f%2fraw.githubusercontent.com%2fmitchcr%2fONEVM%2fmain%2fUEFI%2fUEFI.json)

2. Go to the created VM and look at the Boot Diagnostics - Screenshot and refresh and check at the end of the Serial log and verify the messages printed.  You will see: ">> Start PXE over IPv4 Hyper-V" or "PXE-E16: No valid offer received."
   
3.  Create a VM repair.  Make sure you use a GEN2 VM.
4.  Use the following TSG to fix your VM [How to recover UEFI Partition](https://supportability.visualstudio.com/AzureLinuxNinjas/_wiki/wikis/AzureLinuxNinjas/469439/How-to-Recover-UEFI-Partition)

**Note:**  This procedure can be used if the customer removes any file under /boot/efi, if the partition got deleted or if there was any issue under /boot/efi.

**Expectation:** Your VM should be back now. 


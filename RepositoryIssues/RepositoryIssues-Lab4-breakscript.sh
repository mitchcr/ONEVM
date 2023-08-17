#!/bin/bash
#Custom script to damage Lab2 for Initrd module

cd /etc/products.d
unlink baseproduct
ln -s sle-module-toolchain.prod baseproduct 
registercloudguest --force-new


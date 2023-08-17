#!/bin/bash

cd /etc/products.d
unlink baseproduct
ln -s sle-module-toolchain.prod baseproduct 
registercloudguest --force-new


#!/bin/sh

ID=$(date "+%Y%M%H%m%d%S")

VBoxManage createvm --name stork_pxe_$ID --register
VBoxManage createhd --filename stork_pxe_$ID.vdi --size 4000 --variant Standard
VBoxManage storagectl stork_pxe_$ID --name "IDE Controller" --add ide --controller PIIX4
VBoxManage storageattach stork_pxe_$ID --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium stork_pxe_$ID.vdi
VBoxManage modifyvm stork_pxe_$ID --nic1 hostonly --cableconnected1 on --hostonlyadapter1 vboxnet0 
VBoxManage modifyvm stork_pxe_$ID --boot1 net
VBoxManage modifyvm stork_pxe_$ID --boot2 disk
VBoxManage modifyvm stork_pxe_$ID --boot3 none
VBoxManage modifyvm stork_pxe_$ID --boot4 none

VBoxManage startvm stork_pxe_$ID

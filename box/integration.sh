#!/bin/sh

# Make sure that virtualbox is not running dhcp on the host interface
VBoxManage dhcpserver remove --netname HostInterfaceNetworking-vboxnet0

ID=$(date "+%Y%M%H%m%d%S")
MAC=$(echo $1 | sed 's/://g' | tr '[:lower:]' '[:upper:]')

VBoxManage createvm --name stork_pxe_$ID --ostype RedHat_64 --register

VBoxManage createhd --filename stork_pxe_$ID.vmdk --format VMDK --size 4000 --variant Standard
VBoxManage storagectl stork_pxe_$ID --name "IDE Controller" --add ide --controller PIIX4 --hostiocache on --bootable on
VBoxManage storageattach stork_pxe_$ID --storagectl "IDE Controller" --port 0 --device 0 --type hdd --medium stork_pxe_$ID.vmdk

VBoxManage modifyvm stork_pxe_$ID --nic1 hostonly 
VBoxManage modifyvm stork_pxe_$ID --cableconnected1 on 
VBoxManage modifyvm stork_pxe_$ID --hostonlyadapter1 vboxnet0
VBoxManage modifyvm stork_pxe_$ID --macaddress1 $MAC
VBoxManage modifyvm stork_pxe_$ID --nictype1 82540EM
VBoxManage modifyvm stork_pxe_$ID --intnet1 intnet

VBoxManage modifyvm stork_pxe_$ID --boot1 net
VBoxManage modifyvm stork_pxe_$ID --boot2 disk
VBoxManage modifyvm stork_pxe_$ID --boot3 none
VBoxManage modifyvm stork_pxe_$ID --boot4 none

VBoxManage modifyvm stork_pxe_$ID --memory 1024

VBoxManage modifyvm stork_pxe_$ID --acpi on
VBoxManage modifyvm stork_pxe_$ID --ioapic on
VBoxManage modifyvm stork_pxe_$ID --rtcuseutc on

VBoxManage startvm stork_pxe_$ID

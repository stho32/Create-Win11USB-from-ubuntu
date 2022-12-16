#!/bin/bash

# Check if the user has specified an ISO file and a USB device
if [ $# -ne 2 ]; then
  echo "Usage: $0 <ISO file> <USB device>"
  exit 1
fi

# Set variables for the ISO file and USB device
iso_file=$1
usb_device=$2

# Check if the ISO file exists
if [ ! -f $iso_file ]; then
  echo "Error: ISO file not found"
  exit 1
fi

# Check if the USB device is a block device
if [ ! -b $usb_device ]; then
  echo "Error: $usb_device is not a block device"
  exit 1
fi

# Check if the USB device is large enough to hold the ISO file
iso_size=$(stat -c%s "$iso_file")
usb_size=$(lsblk -nb -o SIZE "$usb_device")

if [ $iso_size -gt $usb_size ]; then
  echo "Error: $usb_device is not large enough to hold the ISO file"
  exit 1
fi

# Unmount the USB device (if it is already mounted)
umount "$usb_device" 2>/dev/null

# Write the ISO file to the USB device
dd if=$iso_file of=$usb_device bs=4M status=progress

echo "Done! $usb_device has been created as a bootable Windows 11 USB stick."

#!/bin/bash
num=$1
classifier=$2
# This script is only for classification when the VMs and environment has been launched.

# read cloud access credentials from a file. This file is provided via the NeCTAR
# dashboard, under the API access tab, and select EC2 credentials.
if test ! -e ./ec2rc.sh
then
    echo "No ec2rc.sh found in ${PWD}."
    echo "Unable to launch any VM's without cloud access credentials."
    exit
fi

source ./ec2rc.sh


## Get the created instances' ip addresses
echo "Finding IP addresses for VM(s)"
ips=$(python connect.py)
echo "Found address(es): $ips"

# when we pass the list of ips as a parameter to a fab task, we need to
# escape the commas, so that the task sees a single argument containing a
# comma separated list, as opposed to a whole lot of unexpected arguments.
ips_param=$(echo "$ips" | tr , \\,)

## Send the octave code and data to the remote hosts in parallel
fab -H $ips -u ubuntu -P transmit_data:$ips_param

#fab -i my_keypair.pem -H $ips -u ubuntu -P remove_file
#fab -i my_keypair.pem -H $ips -u ubuntu -P transmit_octave_code
#fab -i my_keypair.pem -H $ips -u ubuntu -P transmit_data:$ips_param

## Start the classification function on remote hosts in parallel
#time fab -i my_keypair.pem -H $ips -u ubuntu -P classify:$ips_param,$classifier

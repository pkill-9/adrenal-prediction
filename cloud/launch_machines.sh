#!/bin/bash
num=$1

# read cloud access credentials from a file. This file is provided via the NeCTAR
# dashboard, under the API access tab, and select EC2 credentials.
if test ! -e ./ec2rc.sh
then
    echo "No ec2rc.sh found in ${PWD}."
    echo "Unable to launch any VM's without cloud access credentials."
    exit
fi

source ./ec2rc.sh

## Create the certain number of Nectar instances
echo 'Creating new images.'
for (( c=1; c<=$num; c++ ))
do
	nova boot --flavor 0 --key-name my_keypair --image 198869c6-d8f5-4972-8085-e2a5dc1e139d --security-group ssh,http,icmp,default --availability-zone melbourne-np "My Test"
done

nova image-list

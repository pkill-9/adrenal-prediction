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

image_id="ami-000022b3" # Ubuntu 14.04 LTS
keypair_name="${SSH_KEYPAIR_NAME}"

## Create the certain number of Nectar instances
echo 'Creating new images.'
for (( c=1; c<=$num; c++ ))
do
    euca-run-instances --instance-type m1.small --key ${keypair_name} --group default ${image_id}
    # XXX: dead code, delete ASAP
#	nova boot --flavor 0 --key-name ${keypair_name} --image ${image_id} --security-group ssh,http,icmp,default "My Test"
done

# vim: ft=sh ts=4 sw=4 et

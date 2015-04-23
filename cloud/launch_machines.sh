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
    euca-run-instances --instance-type m1.small --key ${keypair_name} \
        --group default ${image_id}
done

# now install necessary packages on the VM's.
echo "Getting instance ip addresses....."
ips=$(python connect.py)
echo "Installing packages on instance(s)"
fab -H ${ips} -u ubuntu -P install_packages

# vim: ft=sh ts=4 sw=4 et

#!/bin/bash
num=$1

export OS_AUTH_URL=https://keystone.rc.nectar.org.au:5000/v2.0/
export OS_TENANT_ID=eb888a3f907f4e539235aebcac1403dd
export OS_TENANT_NAME="TeachingCloudComputing-Team2"
export OS_USERNAME="y.lin1@student.unimelb.edu.au"
export OS_PASSWORD='Nzc5OTczN2JiZjU0ODRh'

## Install the needed software for the local host
# sudo apt-get install python-pip -y
# sudo pip install python-novaclient
# sudo pip install python-keystoneclient
# sudo pip install python-cinderclient
# sudo pip install python-swiftclient
# sudo pip install boto
# sudo pip install fabric

## Create the certain number of Nectar instances
echo 'Creating new images.'
for (( c=1; c<=$num; c++ ))
do
	nova boot --flavor 0 --key-name my_keypair --image 198869c6-d8f5-4972-8085-e2a5dc1e139d --security-group ssh,http,icmp,default --availability-zone melbourne-np "My Test"
done

nova image-list
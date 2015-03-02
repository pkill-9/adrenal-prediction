#!/bin/bash
num=$1
classifier=$2
# echo $classifier

export OS_AUTH_URL=https://keystone.rc.nectar.org.au:5000/v2.0/
export OS_TENANT_ID=eb888a3f907f4e539235aebcac1403dd
export OS_TENANT_NAME="TeachingCloudComputing-Team2"
export OS_USERNAME="y.lin1@student.unimelb.edu.au"
export OS_PASSWORD='Nzc5OTczN2JiZjU0ODRh'

# Install the needed software for the local host
sudo apt-get install python-pip -y
sudo pip install python-novaclient
sudo pip install python-keystoneclient
sudo pip install python-cinderclient
sudo pip install python-swiftclient
sudo pip install boto
sudo pip install fabric

# Create the certain number of Nectar instances
echo 'Create new images.'
for (( c=1; c<=$num; c++ ))
do
	nova boot --flavor 0 --key-name my_keypair --image 198869c6-d8f5-4972-8085-e2a5dc1e139d --security-group ssh,http,icmp,default --availability-zone melbourne-np "My Test"
done

## Get the created instances' ip addresses
ips=$(python connect.py)
echo $ips

## Calculate the number of the instances(-1)
res="${ips//[^,]}"

# Install the octave on remote hosts in parallel 
fab -i my_keypair.pem -H $ips -u ubuntu -P install_octave


num=${#res}
num=$((num+1))

echo "The application will run on: "
echo $num
echo " Nectar VMs."

ip=$(echo "$ips" | tr , _)

## Run the Matlab code to load the excel data and split into pieces
## !!!Need to specify the path that install the Matlab!!!
clear

cd /Applications/MATLAB_R2014a.app/bin
./matlab -nodisplay -nodesktop -r "run ~/Desktop/project/project_1/matlab/load_file($num); "



## Send the octave code and data to the remote hosts in parallel
## !!!Need to specify the path that contains the scripts!!!
echo "Passing the octave code and data to cloud..."
cd ~/Desktop/project/project_1/script
#fab -i my_keypair.pem -H $ips -u ubuntu -P remove_file
#fab -i my_keypair.pem -H $ips -u ubuntu -P transmit_octave_script
#fab -i my_keypair.pem -H $ips -u ubuntu -P transmit_data:$ip

## Start the classification function on remote hosts in parallel
time fab -i my_keypair.pem -H $ips -u ubuntu -P classify:$ip,$classifier,$num

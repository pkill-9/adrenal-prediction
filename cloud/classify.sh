#!/bin/bash
num=$1
classifier=$2
# This script is only for classification when the VMs and environment has been launched.

# Get this from NeCTAR cloud dashboard
export OS_AUTH_URL=https://keystone.rc.nectar.org.au:5000/v2.0/
export OS_TENANT_ID=eb888a3f907f4e539235aebcac1403dd
export OS_TENANT_NAME="TeachingCloudComputing-Team2"
export OS_USERNAME="y.lin1@student.unimelb.edu.au"
export OS_PASSWORD='Nzc5OTczN2JiZjU0ODRh'


## Get the created instances' ip addresses
ips=$(python connect.py)
echo $ips

## Calculate the number of the instances(-1)
res="${ips//[^,]}"

num=${#res}
num=$((num+1))

echo "The application will run on: "
echo $num
echo " Nectar VMs."

ip=$(echo "$ips" | tr , _)

## Run the Matlab code to load the excel data and split into pieces
## !!!Need to specify the path that install the Matlab!!!
# clear
cd /Applications/MATLAB_R2014a.app/bin
time ./matlab -nodisplay -nodesktop -r "run ~/Desktop/project/project_1/matlab/load_file($num); quit"


## Send the octave code and data to the remote hosts in parallel
## !!!Need to specify the path that contains the scripts!!!

cd ~/Desktop/project/project_1/script
#fab -i my_keypair.pem -H $ips -u ubuntu -P remove_file
#fab -i my_keypair.pem -H $ips -u ubuntu -P transmit_octave_code
#fab -i my_keypair.pem -H $ips -u ubuntu -P transmit_data:$ip

## Start the classification function on remote hosts in parallel
time fab -i my_keypair.pem -H $ips -u ubuntu -P classify:$ip,$classifier

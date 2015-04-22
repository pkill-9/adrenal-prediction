
import os
import boto
import time
from boto.ec2.regioninfo import RegionInfo
from pprint import pprint

# set region and keys
ec2_endpoint = os.environ.get ('EC2_URL')
region = RegionInfo (name = 'melbourne', endpoint = 'nova.rc.nectar.org.au')
access_key = os.environ.get ('EC2_ACCESS_KEY')
access_secret = os.environ.get ('EC2_SECRET_KEY')
ssh_keypair_name = os.environ.get ('SSH_KEYPAIR_NAME')

# check if the instances and volumes are ready 
def check_ready():
    for instance in instances:
        if instance.key_name==ssh_keypair_name:
            num_retries = 24
            status = instance.update ()
            debug_print ('Waiting for VM to start: ' + instance.private_dns_name)

            while status != 'running':
                debug_print ('Still waiting.....')
                status = instance.update ()
                time.sleep(10)
                num_retries-=1
                if num_retries < 0:
                    debug_print (instance.private_dns_name + ': Timed out')
                    break
        else:
            continue

def debug_print (message):
    print (message, file = sys.stderr)


if __name__=='__main__':
    # establish connection
    connection=boto.connect_ec2(aws_access_key_id=access_key,aws_secret_access_key=access_secret,
                          is_secure=True,region=region,port=8773,path='/services/Cloud',validate_certs=False)
    reservations=connection.get_all_reservations()
    instances = [instance for r in reservations for instance in r.instances]
    
    check_ready()

    # get the ip address of each VM.
    ips = ''

    for instance in instances:
        if instance.update () != 'running':
            continue

        if instance.key_name == ssh_keypair_name:
            ips +=  instance.ip_address + ','

    # remove the trailing comma.
    ips = ips[:-1]
    print ips
    

            
            






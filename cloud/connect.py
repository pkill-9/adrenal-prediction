
import boto
import time
from boto.ec2.regioninfo import RegionInfo

# set region and keys
ec2_endpoint = os.environ.get ('EC2_URL')
region = RegionInfo (name = 'melbourne', endpoint = ec2_endpoint)
access_key = os.environ.get ('EC2_ACCESS_KEY')
access_secret = os.environ.get ('EC2_SECRET_KEY')

# check if the instances and volumes are ready 
def check_ready():
    for instance in instances:
        if instance.private_dns_name=='my-test':
            num_retries = 6

            while (status = instance.update ()) != 'running':
                time.sleep(10)
                num_retries-=1
                if num_retries < 0:
                    break
        else:
            continue



if __name__=='__main__':
    # establish connection
    connection=boto.connect_ec2(aws_access_key_id=access_key,aws_secret_access_key=access_secret,
                          is_secure=True,region=region,validate_certs=False)
    reservations=connection.get_all_reservations()
    instances = [instance for r in reservations for instance in r.instances]
    
    check_ready()

    # get the ip address of each VM.
    ips = ''

    for instance in instances:
        if instance.private_dns_name=='my-test':                   
            ips +=  instance.ip_address + ','

    # remove the trailing comma.
    ips = ips[:-1]
    print ips
    

            
            






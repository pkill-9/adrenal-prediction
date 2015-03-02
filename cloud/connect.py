
import boto
import time
from boto.ec2.regioninfo import RegionInfo

# set region and keys
region=RegionInfo(name='melbourne',endpoint='nova.rc.nectar.org.au')
access_key='9d1c232e2fe443a8a29239fd113b359c'       
access_secret='6dd011a67d0f4958945006572258bfc0'   

# check if the instances and volumes are ready 
def check_ready():
    for instance in instances:
        if instance.private_dns_name=='my-test':
            status = instance.update()
            x = 6
            while status != 'running':
                time.sleep(10)
                x-=1
                status = instance.update()
                if x < 0:
                    break
        else:
            continue



if __name__=='__main__':
    # establish connection
    connection=boto.connect_ec2(aws_access_key_id=access_key,aws_secret_access_key=access_secret,
                          is_secure=True,region=region,port=8773,path='/services/Cloud',validate_certs=False)
    reservations=connection.get_all_reservations()
    instances = [instance for r in reservations for instance in r.instances]
    
    check_ready()
    # get the id of each instance and volume 
    ips = ''
    for instance in instances:
        #print instance.private_dns_name
        if instance.private_dns_name=='my-test':                   
            ips +=  instance.ip_address+','
    ips = ips[:-1]
    print ips
    

            
            






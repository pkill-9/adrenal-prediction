from fabric.api import *

def install_octave():
	with hide('stdout'):
		run('sudo apt-get update')
		run('sudo apt-get install -y octave')
		run('sudo apt-get install -y liboctave-dev')
		run('mkdir -p /home/ubuntu/octave')
		run('mkdir -p /home/ubuntu/octave/octave_code/data')

def remove_file():
	with hide('stdout'):
		sudo('rm -r -f /home/ubuntu/octave')

def transmit_octave_code():
	with hide('stdout'):
		put('../octave_code','/home/ubuntu/octave')

def transmit_octave_script():
	with hide('stdout'):
		put('../octave_code/script.m','/home/ubuntu/octave/octave_code')

def transmit_data(ip):
	ips = ip.split('_')
	ind = ips.index(env.host)+1
	ind = str(ind)
	with hide('stdout'):
		put('../data/input.mat','/home/ubuntu/octave/octave_code')
		

def classify(ip,classifier,num):
	ips = ip.split('_')
	ind = ips.index(env.host)+1
	ind = str(ind)
	with hide('stdout'):
		put('../octave_code/script.m','/home/ubuntu/octave/octave_code')
		put('../data/input.mat','/home/ubuntu/octave/octave_code')
		run('cd octave/octave_code;octave --silent --eval \'script('+classifier+','+ind+','+num+')\'')		
		get('/home/ubuntu/octave/octave_code/output'+ind+'.txt','output'+ind+'.txt')

		with open('output'+ind+'.txt') as f:
			with open("output.txt", "a") as f1:
				for line in f:
					f1.write(line) 
		f1.close()
		f.close()








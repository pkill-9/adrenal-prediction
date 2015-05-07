import os
from fabric.api import *


def install_packages ():
    run ("sudo apt-get update")
    run ("sudo apt-get install -y octave")
    run ("sudo apt-get install -y liboctave-dev")
    run ("sudo apt-get install -y git")
    run ("git clone https://github.com/pkill-9/adrenal-prediction.git")
    run ("mkdir /tmp/input /tmp/output")


def transmit_data (ip):
    ips = ip.split (",")
    ind = ips.index (env.host)+1
    ind = str (ind)

    for data_file in os.listdir ("../spool"):
        put ("../input/" + data_file, "/tmp/input/" + data_file)


# vim: ts=4 sw=4 et

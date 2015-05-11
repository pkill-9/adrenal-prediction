import os
from fabric.api import *


def install_packages ():
    run ("sudo apt-get update")
    run ("sudo apt-get install -y octave")
    run ("sudo apt-get install -y liboctave-dev")
    run ("sudo apt-get install -y git")
    run ("git clone https://github.com/pkill-9/adrenal-prediction.git")
    run ("mkdir /tmp/classification")
    run ("mkdir /tmp/classification/input /tmp/classification/output")


def classify_samples (ip):
    ips = ip.split (",")
    ind = ips.index (env.host)+1
    ind = str (ind)

    for data_file in os.listdir ("../input"):
        put ("../input/" + data_file, "/tmp/classification/input/" + 
                data_file)


# vim: ts=4 sw=4 et

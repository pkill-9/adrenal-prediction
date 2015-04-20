#!  /bin/bash
#
# This script installs python libraries which are needed in order to launch
# VM instances. It should be run once as part of installation.
#
# TODO: this script would be rendered unnecessary if we were to use a proper
# package management system such as apt-get. In the long run, that is the
# way to go.

sudo apt-get install python-novaclient
sudo apt-get install fabric

# vim: ts=4 sw=4 et

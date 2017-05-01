#!/bin/bash

echo "Welcome !!! Mode 1.0 environment setup"

. os_install.sh

#echo -n "Please enter environment name and press [ENTER]: "
#read name
name=mode1

#echo -n "Please verify environment name ($name)... is that correct [Yes/No] :" 
#read name
#if [ $name == "Yes" ] || [ $name == "yes" ]; then
#  echo "..."
#else
#   exit 1
#fi

isetup(){

virtualenv /opt/$name

if [ ! -f /opt/$name/bin/activate ]; then
  echo "Virtual ENV not installed properly"
  exit 1
fi

source /opt/$name/bin/activate

if [[ -z "$VIRTUAL_ENV" ]]; then
    echo "No VIRTUAL_ENV set"
else
    echo "VIRTUAL_ENV is set"
fi

if [ ! -f requirements.txt ]; then
  echo "Requirement text is missing"
  exit 0
fi

pip install -r requirements.txt

pip install packages/django-evolution-release-0.6.7.zip
pip install packages/django-mailer_0.2a1.dev3.orig.tar.gz

echo "untar packages/pyexiv2.tar.gz under /opt/clientname/lib/python2.7/site-packages/ directory"
tar -zxvf packages/pyexiv2.tar.gz -C /opt/$name/lib/python2.7/site-packages/

deactivate
echo "Please run below scripts to complete the installation"
echo "Nginx    : generate-nginx-file.sh"
echo "MySQL    : mysql-setup.sh"
echo "Code     : cd /opt/$name && svn co http://svn.example.com/"
echo "Gunicorn : generate-gunicorn-file.sh"
echo "Apache   : generate-apache-file.sh"
}

if  [ -d /opt/$name ]; then
  echo "Environment already exist... "
#uncomment following if client directory already exist
#  isetup
  exit 1
else
  isetup
  exit 0
fi




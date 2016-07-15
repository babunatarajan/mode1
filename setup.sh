#!/bin/bash

echo "Welcome !!! Mode 1.0 webserver installation using Nginx, Gunicorn and MySQL"

echo -n "Please enter client name and press [ENTER]: "
read name

echo -n "Please verify client name ($name)... is that correct [Yes/No] :" 
read clientname
if [ $clientname == "Yes" ] || [ $clientname == "yes" ]; then
  echo "..."
else
   exit
fi

isetup(){
apt-get update
apt-get -y install python-virtualenv
apt-get -y install python-pip
virtualenv /opt/$name

if [ ! -f /opt/$name/bin/activate ]; then
  echo "Virtual ENV not installed properly"
  exit
else
  pass
fi
   
source /opt/$name/bin/activate

#pip install -r packages/pip-requirements.txt
pip install -r requirements.txt

#django-evolution==0.6.7
pip install packages/django-evolution-release-0.6.7.zip

#django-mailer==0.2a1.dev3
pip install packages/django-mailer_0.2a1.dev3.orig.tar.gz

echo "untar packages/pyexiv2.tar.gz under /opt/clientname/lib/python2.7/site-packages/ directory"
tar -zxvf packages/pyexiv2.tar.gz -C /opt/$name/lib/python2.7/site-packages/

deactivate
echo "Please run below scripts to complete the installation"
echo "Nginx    : generate-nginx-file.sh"
echo "MySQL    : mysql-setup.sh"
echo "Code     : cd /opt/$name && svn co http://svn.example.com/"
echo "Gunicorn : generate-gunicorn-file.sh"
}

if  [ -d /opt/$name ]; then
  echo "Client already exist... "
#Temporarly allowing for old directory
  isetup
  exit
else
  isetup
  exit 1
fi




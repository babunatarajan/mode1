#!/bin/bash
SPATH=$(dirname `which $0`)

echo "Welcome !!! Mode 1.0 webserver installation using Nginx, Gunicorn and MySQL"


echo -n "Please enter client name and press [ENTER]: "
read name

echo -n "Please verify client name ($name)... is that correct [Yes/No] :" 
read clientname
if [ $clientname == "Yes" ] || [ $clientname == "yes" ]; then
   echo "Proceeding..."
else
   exit
fi

isetup(){
apt-get update
apt-get -y install python-virtualenv
apt-get -y install python-pip
virtualenv /opt/$name
source /opt/$name/bin/activate

pip install -r packages/pip-requirements.txt

#django-evolution==0.6.7
pip install packages/django-evolution-release-0.6.7.zip

#django-mailer==0.2a1.dev3
pip install packages/django-mailer_0.2a1.dev3.orig.tar.gz

echo "untar packages/pyexiv2.tar.gz under /opt/clientname/lib/python2.7/site-packages/ directory"
tar -zxvf packages/pyexiv2.tar.gz /opt/clientname/lib/python2.7/site-packages/

deactivate
echo "Please run below scripts to complete the installation"
echo "Gunicorn : generate-gunicorn-file.sh"
echo "Nginx    : generate-nginx-file.sh"
echo "MySQL    : mysql-setup.sh"
}

if  [ -d /opt/$name ]; then
  echo "Client already exist... "
  exit
else
  isetup
  exit 1
fi




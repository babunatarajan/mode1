#!/bin/bash

if [ ! -d /etc/apache2 ]; then
   echo -n "Apache not installed... Do you want to install Yes/No : "
   read install
   if [ $install  == "Yes" ]; then
      sudo apt-get update
      sudo apt-get install apache2
   else
      exit 1
   fi
fi

echo -n "Please enter client name and press [ENTER]: "
read name

if [ ! -d /opt/$name/E3 ]; then
   echo "Project folder not available... creating sample project /opt/$name/E3"
   mkdir /opt/$name
   tar zxvf E3.tar.gz -C /opt/$name/
fi

echo "Please enter subdomain or additional names for this client"
echo -n "DOMAIN 1: "
read domain1

echo -n "DOMAIN 2: "
read domain2

echo -n "DOMAIN 3: "
read domain3

echo -n "DOMAIN 4: "
read domain4

echo -n "DOMAIN 5: "
read domain5

echo -n "Enter brand name: "
read brandname

echo "Following are the Apache ports already being used... Use different port"
grep -r "<VirtualHost" /etc/apache2/sites-enabled/*

echo -n "Enter Apache port : "
read apacheport

#Creating Apache Conf File
echo "Generating apache conf file..."
conf(){

rm /etc/apache2/sites-enabled/000-default.conf
cp apache2-ports.conf /etc/apache2/ports.conf
cp apache.conf /etc/apache2/sites-available/"$name".conf
sed -i "s/APACHEPORT/$apacheport/g" /etc/apache2/ports.conf

sed -i "s/CLIENTNAME/$name/g" /etc/apache2/sites-available/"$name".conf
sed -i "s/APACHEPORT/$apacheport/g" /etc/apache2/sites-available/"$name".conf
sed -i "s/CLIENT1/$domain1 $domain2 $domain3 $domain3 $domain4 $domain5/g" /etc/apache2/sites-available/"$name".conf
sed -i "s/BRANDNAME/$brandname/g" /etc/apache2/sites-available/"$name".conf

echo "Enabling Apache conf file $name ..."
cd /etc/apache2/sites-enabled/ && ln -s ../sites-available/"$name".conf .
ls /etc/apache2/sites-enabled/"$name".conf
cd $OLDPWD
echo "Successfully "$name".conf file has been generated"

echo "Creating WSGI file..."
cp wsgi.py /opt/$name/E3/
sed -i "s/CLIENTNAME/$name/g" /opt/$name/E3/wsgi.py  

sudo service apache2 restart

}
echo -n "Please verify client name ($name)... is that correct [Yes/No]: " 
read clientname

if [ $clientname == "Yes" ] || [ $clientname == "yes" ]; then
   if [ -f /etc/apache2/sites-enabled/$name ]; then
      echo -n "Client already exist... You want to overwrite file [Yes/No]: "
      read owrite
      if [ $owrite == "Yes" ] || [ $owrite == "yes" ]; then
         conf
      else
         exit
      fi
   else
      conf
   fi   
else
   exit
fi

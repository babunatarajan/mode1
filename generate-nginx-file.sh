#!/bin/bash

if [ ! -d /etc/nginx ]; then
   echo -n "Nginx not installed... Do you want to install Yes/No : "
   read nginxinstall
   if [ $nginxinstall  == "Yes" ]; then
      sudo apt-get update
      sudo apt-get install nginx
   else
      exit
   fi
fi

echo -n "Please enter client name and press [ENTER]: "
read name

if [ ! -d /opt/$name/E3 ]; then
   echo "Project folder not available please do SVN / Git clone and run the setup"
   exit 1
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
        
grep -i "<VirtualHost" /etc/apache2/sites-enabled/"$name".conf
echo -n "Enter Apache port: "
read apacheport

#Creating Nginx Conf File
echo "Generating nginx conf file..."
conf(){
cp nginx-default /etc/nginx/sites-available/default
cp nginx-index.html /usr/share/nginx/html/index.html
sed -i "s/BRANDNAME/$brandname/g" /usr/share/nginx/html/index.html

cp nginx-conf /etc/nginx/sites-available/$name
sed -i "s/APACHEPORT/$apacheport/g" /etc/nginx/sites-available/$name
sed -i "s/CLIENTNAME/$name/g" /etc/nginx/sites-available/$name
sed -i "s/CLIENT1/$domain1 $domain2 $domain3 $domain4 $domain5/g" /etc/nginx/sites-available/$name 
sed -i "s/BRANDNAME/$brandname/g" /etc/nginx/sites-available/$name

echo "Creating soft link for Nginx Conf file $name ..."
cd /etc/nginx/sites-enabled/ && ln -s ../sites-available/$name .
cd $OLDPWD
echo "Successfully Nginx conf file has been generated"

}

echo -n "Please verify client name ($name)... is that correct [Yes/No]: " 
read clientname

if [ $clientname == "Yes" ] || [ $clientname == "yes" ]; then
   if [ -f /etc/nginx/sites-enabled/$name ]; then
      echo -n "Client already exist... You want to overwrite nginx file [Yes/No]: "
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

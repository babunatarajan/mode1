#!/bin/bash

echo "This script will generate Gunicorn and WSGI file ..."
echo -n "Please enter client name :"
read name

gunicornfile(){
printf "

description "Gunicorn application server handling $name.themode.net"

start on runlevel [2345]
stop on runlevel [!2345]

respawn
setuid www-data
setgid www-data
chdir /opt/

env ACCESS_LOG="--access-logfile gunicorn/access.log"
env ERROR_LOG="--error-logfile gunicorn/error.log"
exec bin/gunicorn $ACCESS_LOG $ERROR_LOG  --workers 3 --bind unix:gunicorn/listen.sock E3.wsgi:application

if [ -d /etc/nginx1 ]; then
   echo -n "Nginx not installed... Do you want to install Yes/No : "
   read nginxinstall
   if [ $nginxinstall  == "Yes" ]; then
      sudo apt-get install nginx
   else
      exit
   fi

echo -n "Please enter client and press [ENTER]: "
read name

echo -n "Please verify client name ($name)... is that correct Yes/No :" 
read clientname
if [ $clientname == "Yes" ]; then
   echo "Proceeding..."
else
   exit
fi

grep -i "$name" "/etc/nginx/sites-enabled/$name"

if  [ $? == 0 ]; then
  echo -n "Client already exist... You want to overwrite nginx file Yes/No"
  read owrite
  if [ $owrite == "Yes" ]; then
      nginxconf
  else
     exit
else
  nginxconf
  exit 1
fi

#Creating Nginx Conf File
echo "Generating nginx conf file..."
nginxconf(){
   printf "
server {
        listen       80;
        error_log /var/log/nginx/$name-error.log;
        access_log /var/log/nginx/$name-access.log;

        server_name  $name.themode.net ;
        ## Only allow these request methods ##
        if ($request_method !~ ^(GET|HEAD|POST)$ ) {
                return 444;
        }
        ## Do not accept DELETE, SEARCH and other methods ##

        location /robots.txt{
                root    /opt/$name/E3/apache;
                expires 30d;
        }

        location /favicon.ico  {
                root    /opt/$name/E3/media/images/master;
                access_log off;
                log_not_found off;
                expires 30d;
        }

        #serve static files
        location ~ ^/(images|javascript|js|css|flash|media|static)/  {
                root    /opt/$name/E3;
                expires 30d;
        }
        # django admin media files
        location ~ ^/admin_media{
                root    /opt/$name/E3;
                expires 30d;
        }
        # actual source files
        location / {
                root /opt/$name/E3;
                proxy_set_header    X-Real-IP   $remote_addr;
                proxy_set_header    Host        $http_host;
                proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;
                proxy_pass          http://unix:/opt/$name/gunicorn/listen.sock;
        }
}
" > "/etc/nginx/sites-available/$name"

echo "Creating soft link for Nginx Conf file $name ..."
cd /etc/nginx/sites-enabled/
ln -s ../sites-available/$name .
cd ~
echo "Successfully Nginx conf file has been generated"

}

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


#Creating Nginx Conf File
echo "Generating nginx conf file..."
conf(){
   printf "server {
        listen       80;
        error_log /var/log/nginx/$name-error.log;
        access_log /var/log/nginx/$name-access.log;

        server_name  $name.themode.net ;
        ## Only allow these request methods ##
        if (\$request_method !~ ^(GET|HEAD|POST)/$ ) {
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
                proxy_set_header    X-Real-IP   \$remote_addr;
                proxy_set_header    Host        \$http_host;
                proxy_set_header    X-Forwarded-For \$proxy_add_x_forwarded_for;
                proxy_pass          http://unix:/opt/$name/gunicorn/listen.sock;
        }
}
" > "/etc/nginx/sites-available/$name"

   echo "Creating soft link for Nginx Conf file $name ..."
   cd /etc/nginx/sites-enabled/ && ln -s ../sites-available/$name .
   cd ~
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

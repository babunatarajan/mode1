#!/bin/bash

echo "This script will generate Gunicorn and WSGI file"

echo -n "Please enter client name and press [ENTER]: "
read name

#[Gunicorn file creation function]
conf(){
echo "Generating gunicorn file..."

printf "
description \"Gunicorn application server handling "$name".BRANDNAME\"

start on runlevel [2345]
stop on runlevel [!2345]

respawn
setuid www-data
setgid www-data
chdir /opt/$name

env ACCESS_LOG=\"--access-logfile gunicorn/access.log\"
env ERROR_LOG=\"--error-logfile gunicorn/error.log\"
exec bin/gunicorn \$ACCESS_LOG \$ERROR_LOG --workers 3 --bind unix:gunicorn/listen.sock E3.wsgi:application
" > "/etc/init/gunicorn-$name.conf"

echo "Successfully created the Gunicorn file..."
echo "You can manage Gunicorn service with following commands"
echo "service gunicorn-$name start/stop/restart" 

printf "
import os
import sys

_parent = lambda x: os.path.normpath(os.path.join(x, '..'))
_gparent = lambda x: os.path.normpath(os.path.join(x, '../..'))

DIRNAME = os.path.dirname(__file__)
PROJECT_ROOT = _parent(DIRNAME)

if not _parent(PROJECT_ROOT) in sys.path:
        sys.path.append(_parent(PROJECT_ROOT))
if not PROJECT_ROOT in sys.path:
        sys.path.append(PROJECT_ROOT)

path = '/opt/$name/E3/'
if path not in sys.path:
    sys.path.insert(0, '/opt/$name/E3')

os.environ['DJANGO_SETTINGS_MODULE'] = 'E3.production_settings'

import django.core.handlers.wsgi
application = django.core.handlers.wsgi.WSGIHandler() 
" > /opt/$name/E3/wsgi.py

sudo mkdir /opt/$name/gunicorn
sudo chown -R www-data:www-data /opt/$name/
}

echo -n "Please verify client name ($name)... is that correct [Yes/No]: " 
read clientname

if [ $clientname == "Yes" ] || [ $clientname == "yes" ]; then
   if [ -d /opt/$name ] && [ ! -d /opt/$name/E3 ]; then
      echo "Client directory exist but E3 folder not available. Please do SVN CO / Git Clone"
      exit
   else
      if [ -f "/etc/init/gunicorn-$name.conf" ]; then
         echo -n "Gunicorn file already exist do you want to overwrite [Yes/No]: "
         read owrite
         if [ $owrite == "Yes" ] || [ $owrite == "yes" ]; then
             conf
         else
             exit
         fi
      else
         conf
      fi
   fi
else
   exit
fi

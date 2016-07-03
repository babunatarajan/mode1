#!/bin/bash

echo "MySQL DB Configuration"

echo -n "Please enter client name and press [ENTER]: "
read name

echo -n "Please enter db username for CMS [ENTER]: "
read cmsname

echo -n "Please enter db password for $cmsname [ENTER]: "
read cmspwd

echo -n "Please enter db username for public [ENTER]: "
read publicname

echo -n "Please enter db password for $publicname [ENTER]: "
read publicpwd

MYSQL=`which mysql`
 
Q1="CREATE DATABASE IF NOT EXISTS $name;"
Q2="CREATE USER $cmsname@localhost identified by '$cmspwd';"
Q3="CREATE USER $publicname@localhost identified by '$publicpwd';"
Q4="GRANT ALL ON $name.* TO '$cmsname'@'localhost';"
Q5="GRANT SELECT ON $name.* TO '$publicname'@'localhost';"
Q6="FLUSH PRIVILEGES;"
SQL="${Q1}${Q2}${Q3}${Q4}${Q5}${Q6}"
 
$MYSQL -uroot -p -e "$SQL"

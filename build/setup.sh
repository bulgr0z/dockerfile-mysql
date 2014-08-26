#!/bin/bash

# If a volume is mounted on /var/lib/mysql, the db installed by apt-get will be replaced by the files in the volume.
#  - if this folder is empty (fresh install), we need to run mysql_install_db in order to start the daemon.
#  - if this folder is not empty, we assume it is a "working" mysql datadir (w/ potential data in it) and do nothing.
if [ "$(ls -A /var/lib/mysql)" ]; then
   echo "========================================================================="
   echo "# The volume mounted on /var/lib/mysql is not empty, mysql_install_db will not run."
   echo "# If you need a fresh mysql db, please clear the volume and re-build the image."
   echo "#"
else
   echo "========================================================================="
   echo "# No database found, installing one."
   /usr/bin/mysql_install_db
   echo "========================================================================="
   echo "# A database has been created in the volume mounted on /var/lib/mysql."
   echo "#"
fi

echo "========================================================================="
echo "#  mysqld is starting, please wait..."
echo "#"

mysqld_safe --skip-syslog > /home/docker_mysql.log 2>&1 &

sleep 1
while ! grep -m1 'ready for connections.' < /var/log/mysql/error.log; do
    sleep 1
done

sleep 5
echo "========================================================================="
echo "#  mysqld is up and running !"


echo "========================================================================="
echo "#  Creating admin account..."

admin_password=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9-_!@#$%^&*()_+{}|:<>?=' | fold -w 12 | head -n 1)
mysql -u root -proot -e "GRANT ALL ON *.* TO 'admin'@'%' IDENTIFIED BY '$admin_password' WITH GRANT OPTION;"

echo "========================================================================="
echo "#"
echo "#  YOUR MYSQL CREDENTIALS"
echo "#    login: admin"
echo "#    password: $admin_password"
echo "#"
echo "#  * root is only accessible from within this container."
echo "#  It does not accept any connection except from localhost."
echo "#"
echo "========================================================================="

service mysql stop
mysqld_safe --skip-syslog

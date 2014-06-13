#!/bin/bash

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
echo "#  It does not accept any connection execpt from localhost."
echo "#"
echo "========================================================================="

service mysql stop
mysqld_safe --skip-syslog

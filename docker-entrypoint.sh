#!/usr/bin/env bash

[ $DEBUG ] && set -x

if [ -f `/app/zentaopms/VERSION` ]; then
  cp -a /var/www/zentaopms/* /app/zentaopms
fi

if [ "`cat /app/zentaopms/VERSION`" != "`cat /var/www/zentaopms/VERSION`" ]; then
  cp -a /var/www/zentaopms/* /app/zentaopms
fi

chmod -R 777 /app/zentaopms/www/data
chmod -R 777 /app/zentaopms/tmp
chmod 777 /app/zentaopms/www
chmod 777 /app/zentaopms/config
chmod -R a+rx /app/zentaopms/bin/*

service apache2 start

chown -R www-data:www-data /app/zentaopms/
chown -R mysql:mysql /var/lib/mysql/
if [ `ls -A /var/lib/mysql/ | wc -w` = 0 ]; then
  echo 'Starting init database'
  mysql_install_db --defaults-file=/etc/mysql/my.cnf
  service mysql start
  /usr/bin/mysqladmin -uroot password $MYSQL_ROOT_PASSWORD
  mysql -uroot -e "UPDATE mysql.user SET plugin='mysql_native_password' WHERE user='root';FLUSH PRIVILEGES;"
else
  service mysql start
fi

if [ `ls -A /app/zentaopms/config/ | wc -w` != 0 ]; then
  rm -f /app/zentaopms/www/install.php /app/zentaopms/www/upgrade.php
fi

tail -f /var/log/apache2/zentao_error_log

#!/bin/ash
if [ -z "${TIMEZONE}" ]; then
    echo "TIMEZONE is unset"
else
    sed -i '980s#.*#date.timezone = \"'$TIMEZONE'\"#' /etc/php82/php.ini
fi
if [ $(ls /glpi/data | wc -l) == "0" ]; then
    cp -r /var/www/html/files/* /glpi/data
fi
if [ -f /glpi/config/glpicrypt.key ] && [ -f /glpi/config/config_db.php ]; then
    rm -rf /var/www/html/install/install.php
fi
chown -R nobody:nobody /glpi
php-fpm82 && lighttpd -D -f /etc/lighttpd/lighttpd.conf
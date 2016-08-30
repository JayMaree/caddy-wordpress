# Caddy-wordpress - jaymaree
# The following could be used to create a caddy service - https://denbeke.be/blog/servers/running-caddy-server-as-a-service/
# 30-08-2016 11:22

# add the php repository
sudo add-apt-repository ppa:ondrej/php

# load the new repository
sudo apt-get update

# install the necessary packages
sudo apt-get install php7.0-mysql mysql-server php7.0-fpm

# configure the basics of mysql ( please, secure it )
sudo /usr/bin/mysql_secure_installation

# create a database
# cli> mysql -u root -p
# or using adminer e.g.

# we will use /var/www/html as 
# mkdir -R /var/www/html

# configure your caddy file at https://caddyserver.com/download
# download it using winscp e.g.
# for example, we downloaded it into ~/

# configure the caddyfile, we used the following as example. do not forget to change it with your settings
cat <<< '
localhost:80 {
        root /var/www/html
        gzip
        #fastcgi / 127.0.0.1:9000 php
        # PHP-FPM with Unix socket
        fastcgi / /var/run/php/php7.0-fpm.sock php
        rewrite {
        if {path} not_match ^\/wp-admin
        to {path} {path}/ /index.php?_url={uri}
        }
}
subdomain.domain.com:80 {
#       subdomain.domain.com:80
        root /var/www/html
        gzip {
        ext *
        level 9
        }
        log access.log
        errors error.log
        fastcgi / /var/run/php/php7.0-fpm.sock php
        rewrite {
        if {path} not_match ^\/wp-admin
        to {path} {path}/ /index.php?_url={uri}
        }
}
' > ~/caddyfile

# jump to /var/www/html
cd /var/www/html

# download and unpack the latest wordpress version
sudo curl -SL http://wordpress.org/latest.tar.gz | sudo tar --strip 1 -xzf -

# we use adminer to manage the mysql databases
sudo git clone https://github.com/vrana/adminer.git

# let's start caddy with the created config file. please change the username
sudo ./caddy -agree -conf="/home/jay/caddyfile"
# use screen sudo ./caddy -agree -conf="/home/jay/caddyfile" if you would like to run caddy as a background process

# visit your IP/hostname and follow the wordpress installation steps.
# before you do, you should chmod the wp-config.php file. Otherwise, you have to copy the settings by yourself into wp-config.php

# let's install proftp which is useful while installing plugins e.g.
sudo apt-get install proftpd

# create a user which could be used with proftpd
sudo useradd ftpwordpress -d /var/www/html -s /bin/bash
# change the password, or use the -p parameter
sudo passwd ftpwordpress

# chmod the necessary folders within /var/www/html

# create and chmod the uploads folders
sudo mkdir /var/www/html/wp-content/uploads | sudo chmod 777 /var/www/html/wp-content/uploads

# THE FOLLOWING LINES ARE CUSTOM, I NEEDED TO INSTALL THESE PACKAGES etc. FOR MY WORDPRESS THEME
sudo apt install php-pear
sudo apt-get install php7.0-dev

# add the exention=zip to the php.ini

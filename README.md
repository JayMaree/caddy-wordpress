# caddy-wordpress
A finetuned Caddy configuration, compatible with Wordpress

## Prerequisites
WordPress has the following [requirements](https://wordpress.org/about/requirements/). However, we used different packages than Wordpress requires.
What you actually need:
- Any linux OS. I used Ubuntu 16.04LTS.
- A freaking fast VM ( because we would like to serve the website really fast..! )

## Create WordPress Database
With all the prerequisites in place, we can go ahead and create a new MySQL database and user for WordPress.

First, log into the MySQL Shell:
````
mysql -u root -p
````

Now, create the database and user:
````
CREATE DATABASE wordpress;
CREATE USER wordpressuser@localhost;
SET PASSWORD FOR wordpressuser@localhost= PASSWORD("password");
GRANT ALL PRIVILEGES ON wordpress.* TO wordpressuser@localhost IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
exit
````

A couple of things are going on here:
1. Create the actual `wordpress` database.
2. Create the user `wordpressuser`.
3. Set a password for this user.
4. Grant all privileges of the `wordpress` database to this user.
5. Reload the new user settings.

Feel free to name you database or user differently.

## Troubleshooting

The most common error you might encounter is `502 Bad Gateway`. In this case, proceed as following:

- Check `/var/log/php7.0-fpm.log` for any errors.
- Add `errors visible` to your `Caddyfile`
- Often times, php-fpm doesn't work because of wrong permissions. Check the error logs and change the user in `/etc/php7.0/fpm/pool.d/www.conf`
- Switching to a Unix socket might help. Change the listen directive in `/etc/php7.0/fpm/pool.d/www.conf` to `listen = unix:/var/run/php7.0-fpm.sock` and adjust your `Caddyfile` accordingly.
- If using a unix socket, make sure Caddy has access to the socket file.

Otherwise, search for guides on how to set up `fastcgi` for Nginx. The configuration for `fastcgi` is identical for Nginx and Caddy, but Nginx has a lot more tutorials online.

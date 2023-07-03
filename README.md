## Dotfiles mainly for linux 

- - -

### Dependencies
- fzf  
- ripgrep  

- - -

### Development Environment
#### Languages
##### python
##### java
##### rust
```bash
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh  
```
##### lua
-$ curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz
-$ tar -zxf lua-5.3.5.tar.gz
-$ cd lua-5.3.5
-$ make linux test
-$ sudo make install

now Lua is installed.

    Download and unpack the LuaRocks tarball using following commands.

-$ wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz
-$ tar zxpf luarocks-3.8.0.tar.gz
-$ cd luarocks-3.8.0

    Run ./configure --with-lua-include=/usr/local/include. (This will attempt to detect your installation of Lua. If you get any error messages, see the section "Customizing your settings", below.)
    Run make.
    As superuser, run make install.

##### PHP
- Install PHP
- Install Web server (Apache or Nginx)
- Install PHP extensions 
php-apache php-cgi php-fpm php-gd  php-embed php-intl php-redis php-snmp

- Install composer (Dependency Manager for PHP)
```bash
$ curl -sS https://getcomposer.org/installer | php
```
- Install laravel
```bash
$ composer global require laravel/installer

```
- Edit PHP config
```bash
$ sudoedit /etc/php/php.ini

```
- Enable PHP extensions, make sure these lines are uncommented (remove the `;` from each line)
```
extention=bcmath
extention=zip
extension=pdo_mysql
extension=mysqli
extension=iconv

extension=gd
extension=imagick
extension=pdo_pgsql
extension=pgsql

```
- Recommended to set correct timezone
```
date.timezone = <Continent/City>
```
- Display errors to debug PHP code
```
display_errors = On
```
- Allow paths to be accessed by PHP
```
open_basedir = /srv/http/:/var/www/:/home/:/tmp/:/var/tmp/:/var/cache/:/usr/share/pear/:/usr/share/webapps/:/etc/webapps/
```


##### dart
##### javascript  
- nvm install/update script  
```bash
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash  
```
- Install node  
```bash
$ nvm install node
```

##### mysql  
- Install MySQL

- Ensure the MySQL service starts when you reboot or startup your machine.
```bash
$ sudo systemctl start mysqld  
```

- Setup MySQL for use
```bash
$ sudo mysql_secure_installation
```

- To check its installed and working just open up mysql command prompt with
```
$ sudo mysql
```

- - -

### Commands


- - -

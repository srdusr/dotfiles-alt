## Dotfiles mainly for linux 
    
- - -  
  
### Dependencies  
- fzf    
- ripgrep    
- ninja  
- cmake  

  
- - -  
  
### Development Environment  
#### Languages  
##### Python  
##### Java  
Recommended to choose Openjdk 8 or 10 otherwise get an error when using Android tools  
##### Rust  
```bash  
$ curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh    
```  
##### Lua  
- Download and install Lua
```bash
$ curl -R -O http://www.lua.org/ftp/lua-5.3.5.tar.gz  
$ tar -zxf lua-5.3.5.tar.gz  
$ cd lua-5.3.5  
$ make linux test  
$ sudo make install  
```
- Download and install LuaRocks
```bash
$ wget https://luarocks.org/releases/luarocks-3.8.0.tar.gz  
$ tar zxpf luarocks-3.8.0.tar.gz  
$ cd luarocks-3.8.0  
```
 - Run this command (This will attempt to detect the installation of Lua and see for any errors)  
 ```bash
 ./configure --with-lua-include=/usr/local/include
 ```
 - Run make  
 ```bash
 $ sudo run make install.  
 ```

##### PHP  
- Install PHP  
- Install Web server (Apache or Nginx)  
- Install PHP extensions   
```
php-apache php-cgi php-fpm php-gd  php-embed php-intl php-redis php-snmp  
mysql-server php8.1-mysql  
phpmyadmin  
```
  
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
  
  
##### Dart  
- Install dart or skip and install flutter (recommended) that includes dart    
```bash  
$ curl -O "https://storage.googleapis.com/dart-archive/channels/be/raw/latest/sdk/dartsdk-linux-x64-release.zip"  
$ unzip dartsdk-linux-x64-release.zip  
$ sudo mv dart-sdk /usr/lib/dart  
```  
NOTE: If Dart SDK is downloaded separately, make sure that the Flutter version of dart is first in path, as the two versions might not be compatible. Use this command `which flutter dart` to see if flutter and dart originate from the same bin directory and are therefore compatible.  
- Install flutter  
```bash  
git clone https://github.com/flutter/flutter.git -b stable  
```  
- Set permissions since only Root has access    
```bash  
$ sudo groupadd flutterusers  
$ sudo gpasswd -a $USER flutterusers  
$ sudo chown -R :flutterusers /opt/flutter  
$ sudo chmod -R g+w /opt/flutter/  
```  
- If still getting any permission denied errors then do this    
```bash  
$ sudo chown -R $USER /opt/flutter  
```  
- Update Flutter Config SDK PATH for custom SDK PATH  
```bash  
$ flutter config --android-sdk /opt/android-sdk  
```  
- Continue to step ***Android Studio*** section to complete setup  
  
##### Javascript    
- nvm install/update script    
```bash  
$ curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash    
```  
- Install node    
```bash  
$ nvm install node  
```  
  
##### MySQL    
- Install MySQL  
  
- Ensure the MySQL service starts when reboot or startup machine.  
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
##### Android Studio  
NOTE: Make sure to properly set the Java environment (either 8 or 10) otherwise android-studio will not start.  
- If Android Studio shows up as a blank window try exporting `_JAVA_AWT_WM_NONREPARENTING=1`.  
- Install android studio either through tarball or available package manager  
  - Tarball  
  ```bash  
  $ curl -L -o android-studio.tar.gz "$(curl -s "https://developer.android.com/studio#downloads" | grep -oP 'https://redirector\.gvt1\.com/[^"]+' | head -n 1)"  
  $ tar -xvzf android-studio.tar.gz  
  $ sudo mv android-studio /opt/  
  $ cd /opt/android-studio/bin script # Configure Android Studio by running this script    
  $ ./studio.sh  
  ```  
  - Available package manager (example yay/AUR)  
  ```bash  
  $ yay android-studio  
  ```  
  - Optional install jetbrains-toolbox that includes android-studio amongst many other applications/tools from jetbrains  
  ```bash  
  $ latest_url=$(curl -sL "https://data.services.jetbrains.com/products/releases?code=TBA" | grep -oP 'https://download.jetbrains.com/toolbox/jetbrains-toolbox-\d+\.\d+\.\d+\.\d+\.tar\.gz' | head -n 1) && curl -L -o jetbrains-toolbox.tar.gz "$latest_url"  
  $ tar -xvzf jetbrains-toolbox.tar.gz  
  $ sudo mv jetbrains-toolbox /opt/jetbrains  
  ```  
  
- Android SDK and tools  
- To install Android SDK and other required tools run these commands in your terminal  
```bash
$ yay -S android-sdk android-sdk-platform-tools android-sdk-build-tools  
$ yay -S android-platform  
```
  
- User permissions, android-sdk is installed in /opt/android-sdk directory, So set the appropriate permissions  
```bash
sudo groupadd android-sdk  
sudo gpasswd -a $USER android-sdk  
sudo setfacl -R -m g:android-sdk:rwx /opt/android-sdk  
sudo setfacl -d -m g:android-sdk:rwX /opt/android-sdk  
```

- Put these lines into .bashrc or .zshrc etc...  
```
# Android Home
export ANDROID_HOME=/opt/android-sdk
export PATH=$ANDROID_HOME/tools:$PATH
export PATH=$ANDROID_HOME/tools/bin:$PATH
export PATH=$ANDROID_HOME/platform-tools:$PATH
# Android emulator PATH
export PATH=$ANDROID_HOME/emulator:$PATH
# Android SDK ROOT PATH
export ANDROID_SDK_ROOT=/opt/android-sdk
export PATH=$ANDROID_SDK_ROOT:$PATH

```
- Android emulator  
- List of available android system images. 
```
$ sdkmanager --list  
```
- Install an android image of your choice. For example.  
```
$ sdkmanager --install "system-images;android-29;default;x86"  
```
- Then create an android emulator  
```
avdmanager create avd -n <name> -k "system-images;android-29;default;x86"  
```
- Continuing from ***Dart(flutter)*** section  
- Accept all of licences by this command  
```
$ flutter doctor --android-licenses  
```
- Run this  
```
$ flutter doctor  
```
- If licences are still not accepted even after running `flutter doctor --android-licences` try these commands and then run `flutter doctor --android-licences again`  
```
$ sudo chown -R $(whoami) $ANDROID_SDK_ROOT  
```
- Install the android SDK command line tools (CLI) or won't be able to accept the android licenses.  
```
yay -S android-sdk-cmdline-tools-latest  
```
- Update emulator binaries  
```
$ sdkmanager --sdk_root=${ANDROID_HOME} tools  
```
- Accept emulator licenses  
```
$ sdkmanager --licenses  
```

- - -  
  
### Commands  
  
  
- - -  

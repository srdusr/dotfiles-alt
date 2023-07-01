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

- - -

### Commands


- - -

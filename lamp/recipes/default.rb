#
# Cookbook:: lamp
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.


script "install_lamp" do
  interpreter "bash"
  user "root"
  cwd "/tmp"
  code <<-EOH
    #!/bin/bash
    
    # How To Install Linux, Apache, MySQL, PHP (LAMP) stack on Ubuntu 16.04
    # https://www.digitalocean.com/community/tutorials/how-to-install-linux-apache-mysql-php-lamp-stack-on-ubuntu-16-04
    
    # PHP My Admin Secure
    # https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-16-04
    
    # =================================================
    # At many places it will ask for your inputs for using disk space
    # or for configurations
    # =================================================
    
    # Update
    apt-get update
    
    # Install cURL & ZIP/UNZIP
    apt-get install curl
    apt-get install zip unzip
    
    # Install Apache
    apt-get install apache2
    # Y to allow to use disk space
    logger "Apache Installed Successfully!"
    
    # Check Firewall Configurations
    logger "Your firewall configuration is."
    ufw app list
    ufw app info "Apache Full"
    ufw allow in "Apache Full"
    ufw allow 22
    ufw allow 80
    ufw allow 443
    
    logger "You can check whether the apache is installed properly by accessing public URL/server IP address."
    # If you can see the page then Apache installation is successful.
    
    # To Remove Existing MySQL Server
    #apt-get remove --purge mysql-server mysql-client mysql-common
    #apt-get remove --purge mysql-*
    #apt-get autoremove
    #apt-get autoclean
    # Other Important Commands
    # dpkg --configure mysql-server-5.5
    
    
    # Install MySQL Server
    apt-get install mysql-server
    # Y to allow to use disk space
    # Enter password for MySQL Root User, Please remeber the password. (Sample ROOT Password: T1umoN23X8W9tPAlQS9)
    
    mysql_secure_installation
    # This asks you if you want to enable secured password for your server.
    # Press y|Y, if you want to allow VALIDATE PASSWORD PLUGIN to be used.
    # If you select Yes, then it will ask you for password strength
    # And to reset password if required (Sample Secure Password : Haksfuh@sfeGa23VhP3)
    
    logger "MySQL Server Installed Successfully!"
    
    # Install PHP
    apt-get install php libapache2-mod-php php-mcrypt php-mysql
    # Y to allow to use disk space
    
    # Inform Apache to prefer php files over html files
    # nano /etc/apache2/mods-enabled/dir.conf
    # Move the index.php at first place
    
    # Install PHP Required Extensions
    apt-get install php-cli php-mbstring php-gettext php-curl
    phpenmod mcrypt
    phpenmod mbstring
    phpenmod curl
    logger "php-cli, curl, mcrypt, mbstring Installed Successfully!"
    
    a2enmod rewrite
    a2enmod ssl
    
    # Install PHP Dev
    apt install php7.0-dev
    logger "php7.0-dev Installed Successfully!"
    
    apt-get install php7.0-intl
    logger "php7.0-intl Installed Successfully!"
    
    # Install PHP Zip Extension
    # apt-get install php7.0-zip
    # logger "PHP Zip Extension Installed Successfully!"
    
    
    # Restart Apache Server
    systemctl restart apache2
    # To See Apache Status
    # systemctl status apache2
    
    logger "Your Home Directory is /var/www/html/. You can start using that Home Directory."
    
    # PHPMyAdmin & Other Extensions
    logger "Installing PHPMyAdmin for DB Access & Other Extensions."
    apt-get install phpmyadmin
    # For the server selection, choose apache2.
    # Select yes when asked whether to use dbconfig-common to set up the database
    # You will be prompted for your database administrator's password
    # You will then be asked to choose and confirm a password for the phpMyAdmin application itself
    
    # =================================================
    # Installing Laravel Specific and other required things
    # such as Git, Composer, Redis for easy PHP Development
    # =================================================
    
    # Install Redis
    # We will need to compile redis from its source. Thus need to install other two packages
    #apt-get install build-essential
    #apt-get install tcl8.5
    #
    #cd /usr/local/bin
    #wget http://download.redis.io/releases/redis-3.2.0.tar.gz
    #tar xzf redis-3.2.0.tar.gz
    #cd redis-3.2.0
    #make
    #make test
    #make install
    #cd utils
    #./install_server.sh
    #logger "Redis Server Installed Successfully!"
    # To Start/Stop Server
    # service redis_6379 start
    # service redis_6379 stop
    #logger "Disable Redis to listen 127.0.0.1 for security purposes."
    #nano /etc/redis/6379.conf
    
    #update-rc.d redis_6379 defaults
    #logger "Redis Server Set to Start at boot!"
    
    # Install GIT
    apt-get install git
    logger "Git Installed Successfully!"
    git config --global user.name "gbanchs"
    git config --global user.email "gabanchsra31@hotmail.com
    
    # Install Composer
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
    logger "Composer Installed Successfully!"
    

    

    
    
    # ==================================================
    # Google Page Speed Module install
    # ==================================================
    dpkg -i mod-pagespeed-*.deb
    apt-get -f install
    
    # ==================================================
    # Create Virtual Host for the server
    # ==================================================
    
    # Downloading Script to Create Virutal Hosts
    #cd /usr/local/bin
    #wget -O virtualhost https://raw.githubusercontent.com/RoverWire/virtualhost/master/virtualhost.sh
    #chmod +x virtualhost
    
    # Set Virtual Host Name
    #virtualhost create mysite.dev
    #systemctl restart apache2
    
    # Git Clone your Site
    #git clone https://github.com/git/git.git /var/www/mysite.dev
    
    # Composer Update
    #cd /var/www/mysite.dev
    #composer install
    
    
    # ==================================================
    # Add a Monitor to keep MySQL, Apache, Supervisor, Redis started in case of any failure
    # ==================================================
    
    # https://www.digitalocean.com/community/tutorials/how-to-use-a-simple-bash-script-to-restart-server-programs

  EOH
end
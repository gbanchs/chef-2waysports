#
# Cookbook:: mysql
# Recipe:: php_install
#
# Copyright:: 2017, The Authors, All Rights Reserved.

include_recipe "apt"

["php", "libapache2-mod-php", "php-mcrypt", "php-mysql", "php7.0-mbstring", "phpunit", "zip", "unzip", "php7.0-zip"].each do |pkg_name|
 package pkg_name
 end


#must enabled sudo a2enmod rewrite
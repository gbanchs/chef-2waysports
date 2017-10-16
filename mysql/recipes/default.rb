#
# Cookbook:: mysql
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

 #config time zone
link "/etc/localtime" do
 to "/usr/share/zoneinfo/America/Los_Angeles"
 end


apt-get update

  apt_repository 'ubuntu-multiverse' do
    uri          'http://archive.ubuntu.com/ubuntu'
    distribution 'trusty'
    components   ['universe']
    deb_src      true
  end

   ["mysql-client-5.6", "mysql-server-5.6"].each do |pkg_name|
    package pkg_name
    end
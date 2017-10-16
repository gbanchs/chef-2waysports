#
# Cookbook:: mysql
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.

 #config time zone
link "/etc/localtime" do
 to "/usr/share/zoneinfo/America/Los_Angeles"
 end

#make update
execute "apt-get update" do
  user "root"
end

def mysqld_initialize_cmd
   cmd = mysqld_bin
   cmd << " --defaults-file=#{etc_dir}/my.cnf"
   cmd << ' --initialize'
   cmd << ' --explicit_defaults_for_timestamp' if v56plus
   return "scl enable #{scl_name} \"#{cmd}\"" if scl_package?
   cmd
 end

  apt_repository 'ubuntu-multiverse' do
    uri          'http://archive.ubuntu.com/ubuntu'
    distribution 'trusty'
    components   ['universe']
    deb_src      true
  end

   ["mysql-client-5.6", "mysql-server-5.6"].each do |pkg_name|
    package pkg_name
    end
# -*- coding: utf-8 -*-
#
# Cookbook Name:: vfn_platform
# Recipe:: default
#
# Copyright 2013, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "git"

iptables_rule "all_ssh"
iptables_rule "all_http"

package "libjpeg-devel"

group "uwsgi" 

user "uwsgi" do
  system true
  comment "uwsgi user"
  shell "/bin/false"
  home "/tmp"
  gid "uwsgi"
end

python_pip "uwsgi" do
  version "1.3"
  action :install
end

directory "/etc/uwsgi" do
  owner "root"
end

directory "/etc/uwsgi" do
  owner "root"
end

directory "/var/log/uwsgi" do
  owner "root"
end

directory "/var/run/uwsgi" do
  owner "root"
end

cookbook_file "/etc/init.d/uwsgi" do
  source "uwsgi.init.d.sh"
  owner "root"
  mode 0755
end

template "/etc/sysconfig/uwsgi" do
  source "uwsgi.erb"
  owner "root"
  mode 0755
end

python_virtualenv node['vfn_platform']['venv'] do
  action :create
end


directory "/tmp/private_code/.ssh" do
  owner node['vfn_platform']['user']
  recursive true
end

cookbook_file "/tmp/private_code/.ssh/id_deploy" do
  source "id_deploy"
  owner node['vfn_platform']['user']
  mode 0600
end

cookbook_file "/tmp/private_code/wrap-ssh4git.sh" do
  source "wrap-ssh4git.sh"
  owner node['vfn_platform']['user']
  mode 0700
end
 

deploy node['vfn_platform']['root'] do
  repo "git@github.com:Amplify-Social/VFNPlatform.git"
  revision node['vfn_platform']['branch']
  ssh_wrapper "/tmp/private_code/wrap-ssh4git.sh"
  user node['vfn_platform']['user']
  symlink_before_migrate.clear
  symlinks.clear
  action :deploy
end

execute "installing platform" do
  cwd "#{node['vfn_platform']['root']}/current/vfn_platform"
  command "#{node['vfn_platform']['venv']}/bin/python setup.py develop"
end

execute "apply package patches" do
  cwd "#{node['vfn_platform']['root']}/current/vfn_platform"
  command "source #{node['vfn_platform']['venv']}/bin/activate && apply_package_patches"  
end

link "/etc/uwsgi/vfn_platform.ini" do
  to "#{node['vfn_platform']['root']}/current/vfn_platform/#{node['vfn_platform']['environment']}.ini"
end

service "uwsgi" do
  action :restart
end


template ::File.join(node['nginx']['dir'],'sites-available','vfn_platform.conf') do
  source 'vfn_platform.conf.erb'
  owner node['nginx']['user']
  group node['nginx']['group']
end

nginx_site "vfn_platform.conf"

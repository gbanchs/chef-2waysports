#
# Cookbook Name:: vfn_platform
# Recipe:: dev
#

include_recipe "git"
include_recipe "vfn_platform::default"

iptables_rule "all_mysql"

mysql_connection_info = {
  :host => "localhost", 
  :username => 'root', 
  :password => node['mysql']['server_root_password']
}

mysql_database 'vfn_platform' do
  connection mysql_connection_info
  action :drop
end

mysql_database 'vfn_platform' do
  connection mysql_connection_info
  action :create
end

mysql_database 'vfn_platform' do
  connection mysql_connection_info
  sql "GRANT ALL ON vfn_platform.* TO vfn@localhost IDENTIFIED BY 'vfn'"
  action :query
end

execute "initialize db" do
  environment ({'UA_PARSER_YAML' => "#{node['vfn_platform']['venv']}/lib/python2.6/site-packages/ua_parser-0.3.2-py2.6.egg/data/regexes.yaml"})
  cwd "#{node['vfn_platform']['root']}/current/vfn_platform"
  command "#{node['vfn_platform']['venv']}/bin/initialize_vfn_platform_db development.ini"
end

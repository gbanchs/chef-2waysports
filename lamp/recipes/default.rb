#
# Cookbook:: lamp
# Recipe:: default
#
# Copyright:: 2017, The Authors, All Rights Reserved.


package 'apache2' do
  package_name node['apache']['package']
  default_release node['apache']['default_release'] unless node['apache']['default_release'].nil?
end

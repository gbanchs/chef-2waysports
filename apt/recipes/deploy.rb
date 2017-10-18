#
# Cookbook:: apt
# Recipe:: deploy
#
# Copyright:: 2017, The Authors, All Rights Reserved.

app = search("aws_opsworks_app").first
application "#{app['shortname']}" do
  owner 'root'
  group 'root'
  repository app['app_source']['url']
  revision   'master'
  path "/srv/#{app['shortname']}"
end

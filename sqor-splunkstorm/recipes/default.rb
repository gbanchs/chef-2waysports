#
# Cookbook Name:: sqor-splunkstorm
# Recipe:: default
#
# Copyright 2013, Sqor
#
# All rights reserved - Do Not Redistribute
#

splunkstorm_monitor "var_log" do
      path "/var/log"
      action :add
end

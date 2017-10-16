#
# Cookbook:: updates
# Recipe:: update
#
# Copyright:: 2017, The Authors, All Rights Reserved.
execute "apt-get-update" do
  command "apt-get update"
  ignore_failure true
  action :nothing
end

package "update-notifier-common" do
  notifies :run, resources(:execute => "apt-get-update"), :immediately
end

execute "apt-get-update-periodic" do
  command "apt-get update"
  ignore_failure true
  only_if do
   File.exists?('/var/lib/apt/periodic/update-success-stamp') &&
   File.mtime('/var/lib/apt/periodic/update-success-stamp') < Time.now - 86400
  end
end

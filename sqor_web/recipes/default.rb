service 'nginx' do
    action :nothing
end

# Create base dir
directory node[:sqor_web][:base] do
    owner "root"
    group "root"
    action :create
end

# install compass
gem_package "sass" do
  version "3.2.10"
end

gem_package "compass"

# Install grunt
npm_package "grunt-cli"

# pulling from git
git node[:sqor_web][:base] do
    repository node[:sqor_web][:git][:uri]
    reference node[:sqor_web][:git][:deploy_tag]
    action :sync
end

# Copy config for env
bash "copy_config" do
    cwd "#{node[:sqor_web][:base]}/www/js"
    user "root"
    code <<-EOH
        cp config/#{node[:sqor_web][:config_env]}.js ./config.js
    EOH
end

# Build
bash "build" do
  cwd node[:sqor_web][:base]
  user "root"
  code <<-EOH
      npm install
      grunt build
  EOH
end

template "#{node['nginx']['dir']}/sites-available/#{node[:sqor_web][:name]}" do
    source "nginx.config.erb"
    variables({
	:root => node[:sqor_web][:base],
	:api_url => node[:sqor_rest][:url],
  :rest_url => node[:sqor_web][:rest_url] 
    })
    notifies :restart, 'service[nginx]'
end

nginx_site node[:sqor_web][:name] do
    enable true
end

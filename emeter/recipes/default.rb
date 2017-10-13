ENV['DIST_STORE_CONTACT_NODE1'] = node[:contact_node1]
ENV['DIST_STORE_CONTACT_NODE2'] = node[:contact_node2]
ENV['SQOR_DEPLOY_ENV'] = node[:env]
ENV['DB_HOST'] = node[:db][:host]
ENV['DB_PASSWORD'] = node[:db][:password]
ENV['DB_USER'] = node[:db][:user]
# ENV['DB_PORT'] = node[:db][:port]
ENV['DB_DB_NAME'] = node[:db][:name]
ENV['emeter_HTTP_PORT'] = node[:api_port]
ENV['DB_RIAK_URL'] = node[:riak]

# Service
execute "service_stop" do
    cwd node[:emeter][:base_dir]
    command "rel/emeter/bin/emeter stop"
    #Only stop if the ping comes back with an exit status of 0
    only_if "/opt/emeter/rel/emeter/bin/emeter ping" 
end

# Create base dir
directory node[:emeter][:base_dir] do
    owner "root"
    group "root"
    action :create
end

# Pull from github
git node[:emeter][:base_dir] do
    repository node[:emeter][:git][:url]
    reference node[:emeter][:git][:deploy_tag]
    action :sync
end

# Build
execute "make" do
    cwd node[:emeter][:base_dir]
    command "rm -rf deps && make clean && make get-deps && make && make release "
    action :run
end

# Service
execute "service_start" do
    cwd node[:emeter][:base_dir]
    command "rel/emeter/bin/emeter start"
    action :run
end

ENV['DIST_STORE_CONTACT_NODE1'] = node[:contact_node1]
ENV['DIST_STORE_CONTACT_NODE2'] = node[:contact_node2]
ENV['SQOR_DEPLOY_ENV'] = node[:env]
ENV['DB_HOST'] = node[:db][:host]
ENV['DB_PASSWORD'] = node[:db][:password]
ENV['DB_USER'] = node[:db][:user]
# ENV['DB_PORT'] = node[:db][:port]
ENV['DB_DB_NAME'] = node[:db][:name]
ENV['DB_POOL_SIZE'] = node[:db][:pool_size]
ENV['SQOR_REST_HTTP_PORT'] = node[:api_port]
ENV['DB_RIAK_URL'] = node[:riak]

# Service
execute "service_stop" do
    cwd node[:sqor_rest][:base_dir]
    command "rel/sqor_rest/bin/sqor_rest stop"
    only_if do FileTest.directory?(node[:sqor_rest][:rel_dir]) end
end

# Create base dir
directory node[:sqor_rest][:base_dir] do
    owner "root"
    group "root"
    action :create
end

# Pull from github
git node[:sqor_rest][:base_dir] do
    repository node[:sqor_rest][:git][:url]
    reference node[:sqor_rest][:git][:deploy_tag]
    action :sync
end

# Build
execute "make" do
    cwd node[:sqor_rest][:base_dir]
    command "rm -rf deps && make clean && make get-deps && make && make release #{node[:env]}"
    action :run
end

# Service
execute "service_start" do
    cwd node[:sqor_rest][:base_dir]
    command "rel/sqor_rest/bin/sqor_rest start"
    action :run
end

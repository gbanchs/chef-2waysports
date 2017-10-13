ENV['DIST_STORE_CONTACT_NODE1'] = node[:contact_node1]
ENV['DIST_STORE_CONTACT_NODE2'] = node[:contact_node2]

# Service
execute "service_stop" do
    cwd node[:sqor_contact][:base_dir]
    command "rel/contact_node/bin/contact_node stop"
    only_if do FileTest.directory?(node[:sqor_contact][:base_dir]) end
end

# Create base dir
directory node[:sqor_contact][:base_dir] do
    owner "root"
    group "root"
    action :create
end

# Pull from github
git node[:sqor_contact][:base_dir] do
    repository node[:sqor_contact][:git][:url]
    reference node[:sqor_contact][:git][:deploy_tag]
    action :sync
end

# Build
execute "make" do
    cwd node[:sqor_contact][:base_dir]
    command "./rebar update-deps && make get-deps && make && make release"
    action :run
end

# Service
execute "service_start" do
    cwd node[:sqor_contact][:base_dir]
    command "rel/contact_node/bin/contact_node start"
    action :run
end


# This will have to wait for now
#Boto.contact('dev').each do |c|
#    env 'DIST_STORE_CONTACT_NODE1' do
#	value c['Hostname']
#    end
#    env 'DIST_STORE_CONTACT_NODE2' do
#	value node['hostname']
#    end
#end

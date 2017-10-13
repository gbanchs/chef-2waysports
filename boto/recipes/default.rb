#install fresh and fancy boto
python_pip "git+#{node['boto']['git']['url']}@#{node['boto']['git']['tag']}" do
    action :install
end

directory '/opt' do
    owner "root"
    group "root"
    mode 0755
    action :create
end

directory '/opt/sqor' do
    owner "root"
    group "root"
    mode 0755
    action :create
end

cookbook_file '/opt/sqor/boto_opsworks.py' do
    source 'boto_opsworks.py'
    mode 0755
    owner "root"
    group "root"
end

env 'AWS_ACCESS_KEY_ID' do
    value "AKIAJ7IOL7OS4357ZABA"
end

env 'AWS_SECRET_ACCESS_KEY' do
    value 'TBxEMQ8NbsFNx1hTfkfWVwtpib83VYzz2DVMYVDO'
end


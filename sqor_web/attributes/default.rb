default['sqor_web']['name'] = 'sqor_web'
default['sqor_web']['root'] = '/usr/local'
default['sqor_web']['base'] = File.join(node[:sqor_web][:root], node[:sqor_web][:name])
default['sqor_web']['git']['uri'] = 'git@github.com:Amplify-Social/sqor_web.git'
default['sqor_web']['git']['deploy_tag'] = 'develop'
default['sqor_web']['rest_url'] = 'http://rest-dev.sqor.com'

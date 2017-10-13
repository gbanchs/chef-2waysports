require 'json'

class Chef::Recipe::Boto
    def self.contact(env)
        JSON.parse(`./opt/sqor/boto_opsworks.py instance list '#{env}:contact server'`)
    end
end

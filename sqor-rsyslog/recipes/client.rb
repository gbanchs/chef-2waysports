include_recipe "rsyslog::client"

resources(:template => "/etc/rsyslog.d/50-default.conf").instance_exec do
    cookbook "sqor-rsyslog"
end

include_recipe "rsyslog::server"

resources(:template => "/etc/rsyslog.d/35-server-per-host.conf").instance_exec do
    cookbook "sqor-rsyslog"
end

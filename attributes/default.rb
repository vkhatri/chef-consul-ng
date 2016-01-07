default['consul']['version'] = '0.6.0'
default['consul']['disable_service'] = false

default['consul']['packages'] = %w(unzip)

default['consul']['notify_restart'] = true
default['consul']['version_purge'] = false

default['consul']['package_url'] = 'auto'
default['consul']['webui_package_url'] = 'auto'

default['consul']['user'] = 'consul'
default['consul']['group'] = 'consul'
default['consul']['setup_user'] = true

default['consul']['enable_webui'] = false

default['consul']['mode'] = 0754
default['consul']['umask'] = 0023

default['consul']['conf_dir'] = '/etc/consul'
default['consul']['conf_file'] = '/etc/consul/000-consul.json'
default['consul']['parent_dir'] = '/usr/local/consul'
default['consul']['log_dir'] = '/var/log/consul'
default['consul']['pid_dir'] = '/var/run/consul'

default['consul']['diplomat_gem_version'] = nil
default['consul']['install_diplomat_gem'] = false # enable it on specific node to manage acl

# http://www.consul.io/docs/agent/options.html
default['consul']['config']['bootstrap'] = false
default['consul']['config']['server'] = false
default['consul']['config']['datacenter'] = nil
default['consul']['config']['data_dir'] = '/var/lib/consul'
default['consul']['config']['encrypt'] = nil
default['consul']['config']['log_level'] = 'INFO'
default['consul']['config']['bind_addr'] = node['ipaddress']
default['consul']['config']['client_addr'] = node['ipaddress']
default['consul']['config']['start_join'] = []
default['consul']['config']['ports']['server'] = 8_300
default['consul']['config']['ports']['serf_lan'] = 8_301
default['consul']['config']['ports']['serf_wan'] = 8_302
default['consul']['config']['ports']['rpc'] = 8_400
default['consul']['config']['ports']['dns'] = 8_600
default['consul']['config']['ports']['http'] = 8_500

# default['consul']['config']['acl_master_token'] =
# default['consul']['config']['acl_token'] =
# default['consul']['config']['server_name'] =
# default['consul']['config']['verify_outgoing'] =
# default['consul']['config']['retry_interval'] =
# default['consul']['config']['disable_update_check'] =
# default['consul']['config']['acl_ttl'] =
# default['consul']['config']['start_join_wan'] =
# default['consul']['config']['verify_server_hostname'] =
# default['consul']['config']['skip_leave_on_interrupt'] =
# default['consul']['config']['domain'] =
# default['consul']['config']['acl_down_policy'] =
# default['consul']['config']['protocol'] =
# default['consul']['config']['acl_default_policy'] =
# default['consul']['config']['verify_incoming'] =
# default['consul']['config']['enable_syslog'] =
# default['consul']['config']['watches'] =
# default['consul']['config']['disable_remote_exec'] =
# default['consul']['config']['leave_on_terminate'] =
# default['consul']['config']['dns_config'] =
# default['consul']['config']['bootstrap_expect'] =
# default['consul']['config']['advertise_addr_wan'] =
# default['consul']['config']['recursor'] =
# default['consul']['config']['advertise_addr'] =
# default['consul']['config']['node_name'] =
# default['consul']['config']['retry_join'] =
# default['consul']['config']['addresses'] =
# default['consul']['config']['statsite_addr'] =
# default['consul']['config']['enable_debug'] =
# default['consul']['config']['ui_dir'] =
# default['consul']['config']['check_update_interval'] =
# default['consul']['config']['acl_datacenter'] =
# default['consul']['config']['syslog_facility'] =
# default['consul']['config']['disable_anonymous_signature'] =
# default['consul']['config']['statsd_addr'] =
# default['consul']['config']['recursors'] =

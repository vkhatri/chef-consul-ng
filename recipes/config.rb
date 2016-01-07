#
# Cookbook Name:: consul-ng
# Recipe:: config
#
# Copyright 2015, Virender Khatri
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# if Chef::Resource::ChefGem.instance_methods(false).include?(:compile_time)
#   chef_gem 'chef-sugar' do
#     version node['consul']['chef-sugar_gem_version'] if node['consul']['chef-sugar_gem_version']
#     compile_time true
#   end
# else
#   chef_gem 'chef-sugar' do
#     version node['consul']['chef-sugar_gem_version'] if node['consul']['chef-sugar_gem_version']
#     action :nothing
#   end.run_action(:install)
# end

file 'consul_config_file' do
  path node['consul']['conf_file']
  content JSON.pretty_generate(node['consul']['config'])
  notifies :restart, 'service[consul]' if node['consul']['notify_restart'] && !node['consul']['disable_service']
end

template 'consul_systemd_file' do
  path '/etc/systemd/system/consul.service'
  source "systemd.#{node['platform_family']}.erb"
  mode 0744
  notifies :restart, 'service[consul]' if node['consul']['notify_restart'] && !node['consul']['disable_service']
  only_if { node['init_package'] == 'systemd' }
end

template 'consul_initd_file' do
  path '/etc/init.d/consul'
  source "initd.#{node['platform_family']}.erb"
  mode 0744
  notifies :restart, 'service[consul]' if node['consul']['notify_restart'] && !node['consul']['disable_service']
  only_if { node['init_package'] == 'init' }
end

service_action = node['consul']['disable_service'] ? [:disable, :stop] : [:enable, :start]

service 'consul' do
  supports :status => true, :restart => true, :reload => true
  action service_action
end

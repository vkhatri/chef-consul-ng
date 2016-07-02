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

file 'consul_config_file' do
  path node['consul']['conf_file']
  content JSON.pretty_generate(node['consul']['config'])
  notifies :restart, 'service[consul]' if node['consul']['notify_restart'] && !node['consul']['disable_service']
  only_if { node['consul']['configure'] }
end

template 'consul_systemd_file' do
  path '/etc/systemd/system/consul.service'
  source "systemd.#{node['platform_family']}.erb"
  mode 0o0744
  notifies :restart, 'service[consul]' if node['consul']['notify_restart'] && !node['consul']['disable_service']
  only_if { node['consul']['configure'] && node['init_package'] == 'systemd' }
end

template 'consul_initd_file' do
  path '/etc/init.d/consul'
  source "initd.#{node['platform_family']}.erb"
  mode 0o0744
  notifies :restart, 'service[consul]' if node['consul']['notify_restart'] && !node['consul']['disable_service']
  only_if { node['consul']['configure'] && (%w(init sshd).include? node['init_package']) }
end

if node['os'] == 'windows'
  include_recipe 'nssm'

  nssm 'consul' do
    program ::File.join(node['consul']['install_dir'], 'consul.exe')
    args %(agent -config-dir="""#{node['consul']['conf_dir']}""")
    params(
      AppDirectory: node['consul']['install_dir'],
      AppStdoutCreationDisposition: 4,
      AppStderrCreationDisposition: 4,
      AppRotateFiles: 1,
      AppRotateOnline: 1,
      AppRotateBytes: 1_048_576,
      AppStdout: ::File.join(node['consul']['log_dir'], 'consul.log'),
      AppStderr: ::File.join(node['consul']['log_dir'], 'error.log')
    )
    start false
    only_if { node['consul']['configure'] }
    action :install
  end
end

service_action = node['consul']['disable_service'] ? [:disable, :stop] : [:enable, :start]

service 'consul' do
  supports :status => true, :restart => true, :reload => true
  action service_action
end

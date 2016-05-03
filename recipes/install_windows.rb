#
# Cookbook Name:: consul-ng
# Recipe:: install_windows
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

node.default['consul']['conf_dir'] = ::File.join('C:', node['consul']['conf_dir'])
node.default['consul']['conf_file'] = ::File.join('C:', node['consul']['conf_file'])
node.default['consul']['parent_dir'] = ::File.join('C:', node['consul']['parent_dir'])
node.default['consul']['log_dir'] = ::File.join('C:', node['consul']['log_dir'])
node.default['consul']['pid_dir'] = ::File.join('C:', node['consul']['pid_dir'])
node.default['consul']['config']['data_dir'] = ::File.join('C:', node['consul']['config']['data_dir'])

node.default['consul']['scripts_dir'] = ::File.join(node['consul']['parent_dir'], 'scripts')
node.default['consul']['install_dir'] = ::File.join(node['consul']['parent_dir'], 'consul')
node.default['consul']['version_dir'] = ::File.join(node['consul']['parent_dir'], node['consul']['version'])
node.default['consul']['config']['ui_dir'] = ::File.join(node['consul']['install_dir'], 'dist') if node['consul']['enable_webui']

[node['consul']['parent_dir'],
 node['consul']['version_dir'],
 node['consul']['conf_dir'],
 node['consul']['scripts_dir'],
 node['consul']['pid_dir'],
 node['consul']['config']['data_dir'],
 node['consul']['log_dir']
].each do |dir|
  directory dir do
    recursive true
  end
end

package_url = if node['consul']['package_url'] == 'auto'
                "https://releases.hashicorp.com/consul/#{node['consul']['version']}/consul_#{node['consul']['version']}_#{node['os']}_#{package_arch}.zip"
              else
                node['consul']['package_url']
              end

package_checksum = consul_sha256sum(node['consul']['version'])

webui_package_url = if node['consul']['webui_package_url'] == 'auto'
                      "https://releases.hashicorp.com/consul/#{node['consul']['version']}/consul_#{node['consul']['version']}_web_ui.zip"
                    else
                      node['consul']['webui_package_url']
                    end

webui_package_checksum = webui_sha256sum(node['consul']['version'])

windows_zipfile node['consul']['version_dir'] do
  source package_url
  checksum package_checksum
  action :unzip
  not_if { ::File.exist?(::File.join(node['consul']['version_dir'], 'consul.exe')) }
end

ui_dir = node['consul']['version'] >= '0.6.0' ? ::File.join(node['consul']['version_dir'], 'dist') : node['consul']['version_dir']
windows_zipfile ui_dir do
  source webui_package_url
  checksum webui_package_checksum
  action :unzip
  not_if { ::File.exist?(::File.join(node['consul']['version_dir'], 'dist', 'index.html')) }
end

link node['consul']['install_dir'] do
  to node['consul']['version_dir']
  notifies :restart, 'service[consul]', :delayed
end

windows_path node['consul']['install_dir'] do
  action :add
end

# purge older versions
ruby_block 'purge_old_versions' do
  block do
    require 'fileutils'
    installed_versions = Dir.entries(node['consul']['parent_dir']).reject { |a| a =~ /^\.{1,2}$|^[a-zA-Z]/ }.sort
    old_versions = installed_versions - [node['consul']['version']]

    old_versions.each do |v|
      v = ::File.join(node['consul']['parent_dir'], v)
      FileUtils.rm_rf Dir.glob(v)
      puts "\ndeleted consul older version '#{v}'"
      Chef::Log.warn("deleted consul older version #{v}")
    end
  end
  only_if { node['consul']['version_purge'] }
end

if Chef::Resource::ChefGem.method_defined?(:compile_time)
  chef_gem 'diplomat' do
    compile_time true
    version node['consul']['diplomat_gem_version'] if node['consul']['diplomat_gem_version']
    only_if { node['consul']['install_diplomat_gem'] }
  end
else
  chef_gem 'diplomat' do
    version node['consul']['diplomat_gem_version'] if node['consul']['diplomat_gem_version']
    action :nothing
    only_if { node['consul']['install_diplomat_gem'] }
  end.run_action(:install)
end

#
# Cookbook Name:: consul-ng
# Recipe:: install
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

node['consul']['packages'].each do |p|
  package p
end

include_recipe 'consul-ng::user'

[node['consul']['parent_dir'],
 node['consul']['version_dir'],
 node['consul']['conf_dir'],
 node['consul']['scripts_dir'],
 node['consul']['pid_dir'],
 node['consul']['config']['data_dir'],
 node['consul']['log_dir']].each do |dir|
  directory dir do
    owner node['consul']['user']
    group node['consul']['group']
    mode node['consul']['mode']
    recursive true
    only_if { node['consul']['install'] }
  end
end

package_url = if node['consul']['package_url'] == 'auto'
                "https://releases.hashicorp.com/consul/#{node['consul']['version']}/consul_#{node['consul']['version']}_linux_#{package_arch}.zip"
              else
                node['consul']['package_url']
              end

package_file = ::File.join(node['consul']['version_dir'], ::File.basename(package_url))
package_checksum = node['consul']['install'] ? consul_sha256sum(node['consul']['version']) : nil

webui_package_url = if node['consul']['webui_package_url'] == 'auto'
                      "https://releases.hashicorp.com/consul/#{node['consul']['version']}/consul_#{node['consul']['version']}_web_ui.zip"
                    else
                      node['consul']['webui_package_url']
                    end

webui_package_file = ::File.join(node['consul']['version_dir'], ::File.basename(webui_package_url))
webui_package_checksum = node['consul']['install'] ? webui_sha256sum(node['consul']['version']) : nil

remote_file 'consul_package_file' do
  path package_file
  source package_url
  checksum package_checksum
  only_if { node['consul']['install'] }
end

remote_file 'webui_package_file' do
  path webui_package_file
  source webui_package_url
  checksum webui_package_checksum
  only_if { node['consul']['install'] }
end

execute 'extract_consul_package_file' do
  user node['consul']['user']
  group node['consul']['group']
  umask node['consul']['umask']
  cwd node['consul']['version_dir']
  command "unzip #{package_file}"
  creates ::File.join(node['consul']['version_dir'], 'consul')
  only_if { node['consul']['install'] }
end

execute 'extract_webui_package_file' do
  user node['consul']['user']
  group node['consul']['group']
  umask node['consul']['umask']
  cwd node['consul']['version_dir']
  command node['consul']['version'] >= '0.6.0' ? "unzip #{webui_package_file} -d dist" : "unzip #{webui_package_file}"
  creates ::File.join(node['consul']['version_dir'], 'dist', 'index.html')
  only_if { node['consul']['install'] }
end

link node['consul']['install_dir'] do
  to node['consul']['version_dir']
  notifies :restart, 'service[consul]'
  only_if { node['consul']['install'] }
end

link '/usr/bin/consul' do
  to ::File.join(node['consul']['install_dir'], 'consul')
  only_if { node['consul']['install'] && node['os'] == 'linux' }
end

# purge older versions
ruby_block 'purge_old_versions' do
  block do
    require 'fileutils'
    installed_versions = Dir.entries(node['consul']['parent_dir']).reject { |a| a =~ /^\.{1,2}$|^consul$/ }.sort
    old_versions = installed_versions - [node['consul']['version']]

    old_versions.each do |v|
      v = ::File.join(node['consul']['parent_dir'], v)
      FileUtils.rm_rf Dir.glob(v)
      puts "\ndeleted consul older version '#{v}'"
      Chef::Log.warn("deleted consul older version #{v}")
    end
  end
  only_if { node['consul']['install'] && node['consul']['version_purge'] }
end

if Chef::Resource::ChefGem.method_defined?(:compile_time)
  chef_gem 'diplomat' do
    compile_time true
    version node['consul']['diplomat_gem_version'] if node['consul']['diplomat_gem_version']
    only_if { node['consul']['install'] && node['consul']['install_diplomat_gem'] }
  end
else
  chef_gem 'diplomat' do
    version node['consul']['diplomat_gem_version'] if node['consul']['diplomat_gem_version']
    action :nothing
    only_if { node['consul']['install'] && node['consul']['install_diplomat_gem'] }
  end.run_action(:install)
end

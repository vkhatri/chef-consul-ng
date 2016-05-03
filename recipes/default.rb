#
# Cookbook Name:: consul-ng
# Recipe:: default
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

raise "missing value for attribute node['consul']['config']['datacenter']" unless node['consul']['config']['datacenter']
raise "missing value for attribute node['consul']['config']['encrypt']" unless node['consul']['config']['encrypt']

node.default['consul']['scripts_dir'] = ::File.join(node['consul']['parent_dir'], 'scripts')
node.default['consul']['install_dir'] = ::File.join(node['consul']['parent_dir'], 'consul')
node.default['consul']['version_dir'] = ::File.join(node['consul']['parent_dir'], node['consul']['version'])
node.default['consul']['config']['ui_dir'] = ::File.join(node['consul']['install_dir'], 'dist') if node['consul']['enable_webui']

case node['platform_family']
when 'windows'
  include_recipe 'consul-ng::install_windows'
else
  include_recipe 'consul-ng::install'
end

include_recipe 'consul-ng::config'

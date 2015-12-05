#
# Cookbook Name:: elasticsearch-cluster
# Recipe:: user
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

group node['consul']['group'] do
  system true
  action :create
  only_if { node['consul']['setup_user'] }
end

user node['consul']['user'] do
  system true
  shell '/bin/false'
  gid node['consul']['group']
  action :create
  only_if { node['consul']['setup_user'] }
end

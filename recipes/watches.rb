#
# Cookbook Name:: consul-ng
# Recipe:: watches
#
# Copyright 2018, Joshua Colson
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

node['consul']['watches'].each do |item|
  consul_watch item['name'] do
    name item['name']
    type item['type']
    prefix item['prefix']
    handler item['handler']
    key item['key']
    args item['args']
    handler_type item['handler_type']
    datacenter item['datacenter']
    token item['token']
  end
end

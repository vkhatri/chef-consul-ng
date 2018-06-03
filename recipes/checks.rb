#
# Cookbook Name:: consul-ng
# Recipe:: checks
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

node['consul']['checks'].each do |item|
  consul_check item['name'] do
    id item['id']
    name item['name']
    script item['script']
    args item['args']
    http item['http']
    tcp item['tcp']
    ttl item['ttl']
    docker_container_id item['docker_container_id']
    shell item['shell']
    timeout item['timeout']
    interval item['interval']
    service_id item['service_id']
    initial_status item['initial_status']
  end
end

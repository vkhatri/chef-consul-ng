consul-ng Cookbook
================

[![Cookbook](http://img.shields.io/badge/cookbook-v0.1.0-green.svg)](https://github.com/vkhatri/chef-consul-ng)[![Build Status](https://travis-ci.org/vkhatri/chef-consul.svg?branch=master)](https://travis-ci.org/vkhatri/chef-consul-ng)

This is a [Chef] cookbook to manage [Consul].


>> For Production environment, always prefer the [most recent release](https://supermarket.chef.io/cookbooks/consul-ng).


## Most Recent Release

```
cookbook 'consul-ng', '~> 0.1.0'
```

## From Git

```
cookbook 'consul', github: 'vkhatri/chef-consul-ng'
```

## Repository

https://github.com/vkhatri/chef-consul-ng


## Supported OS

This cookbook was tested on Amazon & Ubuntu Linux and expected to work on other RHEL platforms.


## Recipes

- `consul::default` - default recipe (use it for run_list)

- `consul::user` - setup consul user/group

- `consul::install` - install consul

- `consul::config` - configure consul


## Advanced Attributes


* `default['consul']['version']` (default: `0.5.2`): consul version

* `default['consul']['packages']` (default: `['unzip']`): package dependencies

* `default['consul']['notify_restart']` (default: `true`): whether to restart consul service on configuration file change

* `default['consul']['disable_service']` (default: `false`): whether to disable and stop consul service

* `default['consul']['package_url']` (default: `auto`): download consul package file from hashicorp package repository

* `default['consul']['webui_package_url']` (default: `auto`): download consul webui package file from hashicorp package repository

* `default['consul']['setup_user']` (default: `true`): setup consul user / group

* `default['consul']['enable_webui']` (default: `true`): enable consul webui

* `default['consul']['enable_webui']` (default: `true`): enable consul webui


## Core Attributes

* `default['consul']['packages']` (default: `['unzip']`): package dependencies

* `default['consul']['conf_dir']` (default: `/etc/consul`): consul configuration directory

* `default['consul']['conf_file']` (default: `/etc/consul/000-consul.json`): consul configuration file

* `default['consul']['parent_dir']` (default: `/usr/local/consul`): consul parent directory

* `default['consul']['pid_dir']` (default: `/var/run/consul`): consul service pid directory

* `default['consul']['log_dir']` (default: `/var/log/consul`): consul log directory

* `default['consul']['mode']` (default: `0754`): default directory/file resources mode

* `default['consul']['umask']` (default: `0023`): execute resource attribute

* `default['consul']['user']` (default: `consul`): user name

* `default['consul']['group']` (default: `consul`): group name

* `default['consul']['version_purge']` (default: `false`): purge older versions under `node['consul']['parent_dir']`


## Configuration File 001-consul.json Attributes

* `default['consul']['config']['datacenter']` (default: `nil`): consul configuration attribute, need to **set** this attribute

* `default['consul']['config']['encrypt']` (default: `nil`): consul configuration attribute, need to **set** this attribute

* `default['consul']['config']['start_join']` (default: `[]`): consul configuration attribute, **set this attribute with consul servers ip address**

* `default['consul']['config']['bootstrap']` (default: `false`): consul configuration attribute

* `default['consul']['config']['server']` (default: `false`): consul configuration attribute

* `default['consul']['config']['log_level']` (default: `INFO`): consul configuration attribute

* `default['consul']['config']['bind_addr']` (default: `node['ipaddress']`): consul configuration attribute

* `default['consul']['config']['client_addr']` (default: `node['ipaddress']`): consul configuration attribute

* `default['consul']['config']['ports']['server']` (default: `8300`): consul port

* `default['consul']['config']['ports']['serf_lan']` (default: `8301`): consul port

* `default['consul']['config']['ports']['serf_wan']` (default: `8302`): consul port

* `default['consul']['config']['ports']['rpc']` (default: `8400`): consul port

* `default['consul']['config']['ports']['dns']` (default: `8600`): consul port

* `default['consul']['config']['ports']['http']` (default: `8500`): consul port

For more attribute info, visit below links:

```
http://www.consul.io/docs/agent/options.html
```


## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests (`rake & rake knife`), ensuring they all pass
6. Write new resource/attribute description to `README.md`
7. Write description about changes to PR
8. Submit a Pull Request using Github


## Copyright & License

Authors:: Virender Khatri and [Contributors]

<pre>
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
</pre>


[Chef]: https://www.chef.io/
[consul]: https://consul.io/
[Contributors]: https://github.com/vkhatri/chef-consul/graphs/contributors

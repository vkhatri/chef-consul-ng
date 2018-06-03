consul-ng Cookbook
================

[![Cookbook](http://img.shields.io/badge/cookbook-v0.1.4-green.svg)](https://github.com/vkhatri/chef-consul-ng)[![Build Status](https://travis-ci.org/vkhatri/chef-consul-ng.svg?branch=master)](https://travis-ci.org/vkhatri/chef-consul-ng)

This is a [Chef] cookbook to manage [Hashicorp Consul].


>> For Production environment, always prefer the [most recent release](https://supermarket.chef.io/cookbooks/consul-ng).


## Most Recent Release

```
cookbook 'consul-ng', '~> 0.1.4'
```

## From Git

```
cookbook 'consul-ng', github: 'vkhatri/chef-consul-ng'
```

## Repository

https://github.com/vkhatri/chef-consul-ng


## Supported OS

This cookbook was tested on Amazon & Ubuntu & Centos7 Linux & Windows2012R2 and expected to work on other RHEL platforms.


## Recipes

- `consul-ng::default` - default recipe (use it for run_list)

- `consul-ng::user` - setup consul user/group

- `consul-ng::install` - install consul

- `consul-ng::install_windows` - install consul on windows

- `consul-ng::config` - configure consul

## Attribute Driven Recipes

There are a set of helper recipes that can be run to create various configuration items. These recipes are driven by an `Array` of `Hash` attributes. The keys of each hash match the attributes for the corresponding resource. Only required attributes must be defined in each hash, others may be omitted. If `node['consul']['notify_restart']` attribute is set to true, the consul service will be reloaded after changes are made.

- `consul-ng::acls` - configure access control lists, defined in `node['consul']['acls'][]`

Configuring ACLs is dependent on whether your servers are setup to use them. ACLs can be quite complex so please refer to the Consul documentation for more information.

- `consul-ng::checks` - configure health checks, defined in `node['consul']['checks'][]`

The following example creates two check definitions. The first calls a script created with the `consul_script` resource. The second is a simple http check against the local webserver.

``` ruby
default['consul']['checks'] = [
    {
        'name' => 'proxy_status',
        'notes' => 'Check the status of the proxy host',
        'script' => "#{node['consul']['script_dir']}/consul_script_proxy_status",
        'interval' => '10s'
    },
    {
        'name' => 'web_alive',
        'http' => 'http://localhost:8080/health',
        'interval' => '30s'
    }
]
```

- `consul-ng::scripts` - deploy health check scripts, defined in `node['consul']['scripts'][]`

The following example creates two health check scripts, `consul_script_proxy_status` and `consul_script_web_alive`. The first is a self contained script. This example is intended to demonstrate the `consul-ng::scripts` recipe attribute syntax, but a simple http GET request would be better defined as a `http` type check directly in consul rather than calling an external script. The second example is using a the `cookbook_file` type to deploy a script directly from a cookbook resource.

``` ruby
default['consul']['scripts'] = [
    {
        'name' => 'proxy_status',
        'script_content' => 'curl -s http://localhost:80/health'
    },
    {
        'name' => 'web_alive',
        'cookbook' => 'consul-ng',
        'cookbook_file' => 'web-alive.sh.erb'
    }
]
```

- `consul-ng::services` - configure services, defined in `node['consul']['services'][]`

The following example creates two service definition files, `100-service-web.json` and `100-service-proxy.json`.

``` ruby
default['consul']['services'] = [
    {
        'name' => 'proxy',
        'port' => 80,
        'address' => node['ipaddress']
    },
    {
        'name' => 'web',
        'port' => 8080,
        'address' => node['ipaddress'],
        'tags' => ['rails']
    }
]
```

- `consul-ng::watches` - configure watches, defined in `node['consul']['watches'][]`

``` ruby
default['consul']['watches'] = [
    {
        'name' => 'proxy',
        'type' => 'key',
        'key' => 'proxy',
        'handler_type' => 'script',
        'args' => ['/path/to/handler-script.sh', '-connect', 'redis']
    },
    {
        'name' => 'web',
        'type' => 'nodes',
        'handler_type' => 'script',
        'args' => ['/path/to/node-handler.sh']
    }
]
```

## Advanced Attributes


* `default['consul']['version']` (default: `1.1.0`): consul version

* `default['consul']['packages']` (default: `['unzip']`): package dependencies

* `default['consul']['notify_restart']` (default: `true`): whether to restart consul service on configuration file change

* `default['consul']['disable_service']` (default: `false`): whether to disable and stop consul service

* `default['consul']['package_url']` (default: `auto`): download consul package file from hashicorp package repository

* `default['consul']['webui_package_url']` (default: `auto`): download consul webui package file from hashicorp package repository, included in version 0.9.0+

* `default['consul']['sha256sum_override']` (default: `nil`): override the sha256sum for the consul installation package

* `default['consul']['setup_user']` (default: `true`): setup consul user / group

* `default['consul']['enable_webui']` (default: `true`): enable consul webui

* `default['consul']['enable_webui']` (default: `true`): enable consul webui

* `default['consul']['diplomat_gem_version']` (default: `nil`): diplomat chef gem version

* `default['consul']['install_diplomat_gem']` (default: `true`): install diplomat chef gem

* `default['consul']['configure']` (default: `true`): configure consul

* `default['consul']['install']` (default: `true`): install consul

* `default['consul']['windows_drive_letter']` (default: `C:`): set installation drive for Windows systems


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

* `default['consul']['config']['ports']['rpc']` (default: `8400`): consul port, deprecated in version 0.8.0

* `default['consul']['config']['ports']['dns']` (default: `8600`): consul port

* `default['consul']['config']['ports']['http']` (default: `8500`): consul port

For more attribute info, visit below links:

```
http://www.consul.io/docs/agent/options.html
```

## Custom Resources

### consul_acl

The *consul_acl* resource takes care of provisioning access control lists.

#### Syntax

****

``` ruby
consul_acl 'web' do
    type 'client'
    rules {
        "node" => {
            "" => { "policy" => "read" },
            "app" => { "policy" => "write" },
            "admin" => { "policy" => "deny" }
        }
    }
    token '61f3889e-581b-46b2-903c-667baabf0c45'
end
```

The full syntax for all of the properties that are available to the *consul_acl* resource is:

``` ruby
consul_acl 'name' do
    id String
    url Array
    acl String # defaults to resource block name
    type String
    rules String, Hash
    token String # required
    action Symbol # defaults to :create if not specified
end
```

#### Actions

****

This resource has the following actions:

`:create`
    Default. Create the access control list item.

`:delete`
    Delete the access control list item.

`:nothing`
    Define this resource block to do nothing until notified by another resource to take action. When this resource is notified, this resource block is either run immediately or it is queued up to be run at the end of the Chef Client run.

### consul_check

The *consul_check* resource takes care of provisioning health checks. These items can be found in `node['consul']['conf_dir']/101-check-<name>.json`.

#### Syntax

****

``` ruby
consul_check 'mem-util' do
    id 'mem-util'
    args ["/usr/local/bin/check_mem.py", "-limit", "256MB"]
    interval '30s'
    timeout '1s'
end
```

The full syntax for all of the properties that are available to the *consul_check* resource is:

``` ruby
consul_check 'name' do
    id String
    script String
    args Array
    http String
    tcp String
    docker_container_id String
    shell String
    timeout String
    interval String
    ttl String
    service_id String
    initial_status String
    grpc String
    grpc_use_tls [True, False]
    action Symbol # defaults to :create if not specified
end
```

#### Actions

****

This resource has the following actions:

`:create`
    Default. Create the health check definition file. If a file already exists (but does not match), update that file to match.

`:delete`
    Delete the health check definition file.

`:nothing`
    Define this resource block to do nothing until notified by another resource to take action. When this resource is notified, this resource block is either run immediately or it is queued up to be run at the end of the Chef Client run.

### consul_script

The *consul_script* resource provisions a health check script. These items can be found in `node['consul']['scripts_dir']/consul_script_<name>`.

#### Syntax

****

``` ruby
consul_script 'ping-test' do
    script_content 'ping -c 1 -w 1 remotehost'
end
```

The full syntax for all of the properties that are available to the *consul_script* resource is:

``` ruby
consul_script 'name' do
    name String
    script_content String
    cookbook String # required if using cookbook_file or cookbook_template
    cookbook_file String
    cookbook_template String
    template_variables Hash # variables passed into template resource
    action Symbol # defaults to :create if not specified
end
```

#### Actions

****

This resource has the following actions:

`:create`
    Default. Create the service definition file. If a file already exists (but does not match), update that file to match.

`:delete`
    Delete the service configuration file.

`:nothing`
    Define this resource block to do nothing until notified by another resource to take action. When this resource is notified, this resource block is either run immediately or it is queued up to be run at the end of the Chef Client run.

### consul_service

The *consul_service* resource takes care of provisioning service configuration items. These items can be found in `node['consul']['conf_dir']/100-service-<name>.json`.

#### Syntax

****

``` ruby
consul_service 'web' do
    address node['ipaddress']
    port 8080
end
```

The full syntax for all of the properties that are available to the *consul_service* resource is:

``` ruby
consul_service 'name' do
    id String
    name String
    tags Array
    port Integer
    address String
    enable_tag_override True, False
    checks Array
    token String
    action Symbol # defaults to :create if not specified
end
```

#### Actions

****

This resource has the following actions:

`:create`
    Default. Create the service definition file. If a file already exists (but does not match), update that file to match.

`:delete`
    Delete the service configuration file.

`:nothing`
    Define this resource block to do nothing until notified by another resource to take action. When this resource is notified, this resource block is either run immediately or it is queued up to be run at the end of the Chef Client run.

### consul_watch

The *consul_watch* resource takes care of provisioning consul watches.

#### Syntax

****

``` ruby
consul_watch 'web' do
    type 'key'
    key 'web/nodes/server1'
    handler_type 'script'
    args ['/path/to/handler-script.sh']
end
```

The full syntax for all of the properties that are available to the *consul_watch* resource is:

``` ruby
consul_watch 'name' do
    type String
    prefix String
    key String
    args Array
    handler_type String
    handler String # deprecated in favor of handler_type with args
    http_handler_config Hash
    datacenter String
    token String
    action Symbol # defaults to :create if not specified
end
```

#### Actions

****

This resource has the following actions:

`:create`
    Default. Create the watch item.

`:delete`
    Delete the watch item.

`:nothing`
    Define this resource block to do nothing until notified by another resource to take action. When this resource is notified, this resource block is either run immediately or it is queued up to be run at the end of the Chef Client run.

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
Authors:: Joshua Colson

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

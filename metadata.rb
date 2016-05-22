name 'consul-ng'
maintainer 'Virender Khatri'
maintainer_email 'vir.khatri@gmail.com'
license 'Apache 2.0'
description 'Installs/Configures Hashicorp Consul'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.1.2'

source_url 'https://github.com/vkhatri/chef-consul-ng' if respond_to?(:source_url)
issues_url 'https://github.com/vkhatri/chef-consul-ng/issues' if respond_to?(:issues_url)

%w(ubuntu centos amazon redhat fedora windows).each do |os|
  supports os
end

depends 'nssm', '~> 1.2.0'

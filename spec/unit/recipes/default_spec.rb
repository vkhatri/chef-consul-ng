require 'spec_helper'

describe 'consul-ng::default' do
  shared_examples_for 'consul' do
    context 'all_platforms' do
      it 'install package unzip' do
        expect(chef_run).to install_package('unzip')
      end

      %w(install config).each do |r|
        it "include recipe consul::#{r}" do
          expect(chef_run).to include_recipe("consul-ng::#{r}")
        end
      end

      it 'create group consul' do
        expect(chef_run).to create_group('consul').with(system: true)
      end

      it 'create user consul' do
        expect(chef_run).to create_user('consul').with(system: true)
      end

      %w(/etc/consul /usr/local/consul /usr/local/consul/0.6.4 /var/lib/consul /var/log/consul /var/run/consul /usr/local/consul/scripts).each do |d|
        it "it creates directory #{d}" do
          expect(chef_run).to create_directory(d)
        end
      end

      it 'download consul package file' do
        expect(chef_run).to create_remote_file('consul_package_file')
      end

      it 'download consul webui package file' do
        expect(chef_run).to create_remote_file('webui_package_file')
      end

      it 'extract consul package file' do
        expect(chef_run).to run_execute('extract_consul_package_file')
      end

      it 'extract consul webui package file' do
        expect(chef_run).to run_execute('extract_webui_package_file')
      end

      it 'link /usr/local/consul/consul to current package version directory' do
        expect(chef_run).to create_link('/usr/local/consul/consul')
      end

      it 'run ruby_block purge_old_versions' do
        expect(chef_run).to run_ruby_block('purge_old_versions')
      end

      it 'create /etc/consul/000-consul.json' do
        expect(chef_run).to create_file('/etc/consul/000-consul.json')
      end

      it 'enable consul service' do
        expect(chef_run).to enable_service('consul')
        expect(chef_run).to start_service('consul')
      end
    end
  end

  shared_examples_for 'initd' do
    context 'initd systems' do
      it 'create /etc/init.d/consul' do
        expect(chef_run).to create_template('consul_initd_file').with(path: '/etc/init.d/consul')
      end
    end
  end

  shared_examples_for 'systemd' do
    context 'systemd systems' do
      it 'create consul_systemd_file' do
        expect(chef_run).to create_template('consul_systemd_file').with(path: '/etc/systemd/system/consul.service')
      end
    end
  end

  shared_examples_for 'linux' do
    context 'linux systems' do
      it 'create link /usr/bin/consul' do
        expect(chef_run).to create_link('/usr/bin/consul')
      end
    end
  end

  shared_examples_for 'windows' do
    context 'windows systems' do
      %w(install_windows config).each do |r|
        it "include recipe consul::#{r}" do
          expect(chef_run).to include_recipe("consul-ng::#{r}")
        end
      end
    end
  end

  context 'centos6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.4') do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['init_package'] = 'init'
        node.override['consul']['config']['datacenter'] = 'dc1'
        node.override['consul']['config']['encrypt'] = 'Dt3P9SpKGAR/DIUN1cDirg=='
        node.override['consul']['version_purge'] = true
      end.converge(described_recipe)
    end

    include_examples 'consul'
    include_examples 'initd'
    include_examples 'linux'
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.automatic['platform_family'] = 'debian'
        node.automatic['init_package'] = 'init'
        node.override['consul']['config']['datacenter'] = 'dc1'
        node.override['consul']['config']['encrypt'] = 'Dt3P9SpKGAR/DIUN1cDirg=='
        node.override['consul']['version_purge'] = true
      end.converge(described_recipe)
    end

    include_examples 'consul'
    include_examples 'initd'
    include_examples 'linux'
  end

  context 'centos7' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0') do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['init_package'] = 'systemd'
        node.override['consul']['config']['datacenter'] = 'dc1'
        node.override['consul']['config']['encrypt'] = 'Dt3P9SpKGAR/DIUN1cDirg=='
        node.override['consul']['version_purge'] = true
      end.converge(described_recipe)
    end

    include_examples 'consul'
    include_examples 'systemd'
    include_examples 'linux'
  end

  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
        node.automatic['platform_family'] = 'windows'
        node.override['consul']['config']['datacenter'] = 'dc1'
        node.override['consul']['config']['encrypt'] = 'Dt3P9SpKGAR/DIUN1cDirg=='
        node.override['consul']['version_purge'] = true
      end.converge(described_recipe)
    end

    include_examples 'windows'
  end
end

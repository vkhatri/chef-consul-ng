require 'spec_helper'

describe 'consul-ng::config' do
  shared_examples_for 'all_platforms' do
    it 'enable consul service' do
      expect(chef_run).to enable_service('consul')
      expect(chef_run).to start_service('consul')
    end
  end

  shared_examples_for 'linux' do
    it 'create /etc/consul/000-consul.json' do
      expect(chef_run).to create_file('/etc/consul/000-consul.json')
    end
  end

  shared_examples_for 'windows' do
    it 'create C:/etc/consul/000-consul.json' do
      expect(chef_run).to create_file('C:/etc/consul/000-consul.json')
    end

    it 'include recipe nssm' do
      expect(chef_run).to include_recipe('nssm')
    end

    it 'create nssm service consul' do
      expect(chef_run).to install_nssm('consul').with(
        program: 'C:/usr/local/consul/consul/consul.exe',
        args: 'agent -config-dir="""C:/etc/consul"""'
      )
    end
  end

  shared_examples_for 'initd' do
    it 'create /etc/init.d/consul' do
      expect(chef_run).to create_template('consul_initd_file').with(path: '/etc/init.d/consul')
    end
  end

  shared_examples_for 'systemd' do
    it 'create consul_systemd_file' do
      expect(chef_run).to create_template('consul_systemd_file').with(path: '/etc/systemd/system/consul.service')
    end
  end

  context 'centos6' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '6.4') do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['init_package'] = 'init'
        node.set['consul']['config']['datacenter'] = 'dc1'
        node.set['consul']['config']['encrypt'] = 'Dt3P9SpKGAR/DIUN1cDirg=='
        node.set['consul']['version_purge'] = true
      end.converge('consul-ng::default')
    end

    include_examples 'all_platforms'
    include_examples 'initd'
    include_examples 'linux'
  end

  context 'ubuntu' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'ubuntu', version: '12.04') do |node|
        node.automatic['platform_family'] = 'debian'
        node.automatic['init_package'] = 'init'
        node.set['consul']['config']['datacenter'] = 'dc1'
        node.set['consul']['config']['encrypt'] = 'Dt3P9SpKGAR/DIUN1cDirg=='
        node.set['consul']['version_purge'] = true
      end.converge('consul-ng::default')
    end

    include_examples 'all_platforms'
    include_examples 'initd'
    include_examples 'linux'
  end

  context 'centos7' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'centos', version: '7.0') do |node|
        node.automatic['platform_family'] = 'rhel'
        node.automatic['init_package'] = 'systemd'
        node.set['consul']['config']['datacenter'] = 'dc1'
        node.set['consul']['config']['encrypt'] = 'Dt3P9SpKGAR/DIUN1cDirg=='
        node.set['consul']['version_purge'] = true
      end.converge('consul-ng::default')
    end

    include_examples 'all_platforms'
    include_examples 'systemd'
    include_examples 'linux'
  end

  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
        node.automatic['platform_family'] = 'windows'
        node.set['consul']['config']['datacenter'] = 'dc1'
        node.set['consul']['config']['encrypt'] = 'Dt3P9SpKGAR/DIUN1cDirg=='
        node.set['consul']['version_purge'] = true
      end.converge('consul-ng::default')
    end

    include_examples 'all_platforms'
    include_examples 'windows'
  end
end

require 'spec_helper'

describe 'consul-ng::install_windows' do
  shared_examples_for 'consul' do
    context 'windows' do
      %w(C:/usr/local/consul C:/usr/local/consul/0.6.3 C:/etc/consul C:/usr/local/consul/scripts C:/var/run/consul C:/var/lib/consul C:/var/log/consul).each do |d|
        it "it creates directory #{d}" do
          expect(chef_run).to create_directory(d)
        end
      end

      it 'download and unzip package' do
        expect(chef_run).to unzip_windows_zipfile_to('C:/usr/local/consul/0.6.3')
      end

      it 'download and unzip webuipackage' do
        expect(chef_run).to unzip_windows_zipfile_to('C:/usr/local/consul/0.6.3/dist')
      end

      it 'link C:/usr/local/consul/consul to current package version directory' do
        expect(chef_run).to create_link('C:/usr/local/consul/consul')
      end

      it 'add to windows path' do
        expect(chef_run).to add_windows_path('C:/usr/local/consul/consul')
      end

      it 'run ruby_block purge_old_versions' do
        expect(chef_run).to run_ruby_block('purge_old_versions')
      end

      it 'skip diplomat chef_gem with the default install_diplomat_gem value' do
        expect(chef_run).to_not install_chef_gem('diplomat')
      end
    end
  end

  context 'windows' do
    let(:chef_run) do
      ChefSpec::SoloRunner.new(platform: 'windows', version: '2012R2') do |node|
        node.automatic['platform_family'] = 'windows'
        node.automatic['consul']['config']['datacenter'] = 'dc1'
        node.automatic['consul']['config']['encrypt'] = 'Dt3P9SpKGAR/DIUN1cDirg=='
        node.automatic['consul']['version_purge'] = true
      end.converge('consul-ng::default')
    end

    include_examples 'consul'
  end
end

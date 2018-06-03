# # encoding: utf-8

# Inspec test for recipe consul-ng::default

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

if os.linux?
  # is the unzip package installed?
  describe package('unzip') do
    it { should be_installed }
  end

  # make sure the consul group exists
  describe group('consul') do
    it { should exist }
  end

  # make sure the kana user exists
  describe user('consul') do
    it { should exist }
  end
end

%w[/etc/consul /usr/local/consul /usr/local/consul/1.1.0 /var/lib/consul /var/log/consul /var/run/consul /usr/local/consul/scripts].each do |d|
  describe directory(d.to_s) do
    it { should exist }
  end

  if os.linux?
    describe directory(d.to_s) do
      it { should be_owned_by 'consul' }
      its('mode') { should cmp 0o0754 }
    end
  end
end

%w[/etc/consul/000-consul.json].each do |f|
  # restricted permissions on config file
  describe file(f.to_s) do
    it { should exist }
  end

  if os.linux?
    # restricted permissions on config file
    describe file(f.to_s) do
      its('mode') { should cmp '0644' } # unless os.windows?
    end
  end
end

# validate the service
describe service('consul') do
  it { should be_installed }
  it { should be_enabled }
  it { should be_running }
end

# the ports should be listening
[8301, 8500, 8600].each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

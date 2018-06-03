# # encoding: utf-8

# Inspec test for recipe consul-ng::config

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

describe command('dig @localhost -p 8600 web.service.dev') do
  its('stdout') { should match(/0\s+IN\s+A/) }
  # its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

describe command('curl -s http://localhost:8500/v1/catalog/service/web') do
  its('stdout') { should match(/"ServiceName":"web"/) }
  its('stderr') { should eq '' }
  its('exit_status') { should eq 0 }
end

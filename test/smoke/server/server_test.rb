# # encoding: utf-8

# Inspec test for recipe consul-ng::config

# The Inspec reference, with examples and extensive documentation, can be
# found at http://inspec.io/docs/reference/resources/

# the ports should be listening
[8300, 8302].each do |p|
  describe port(p) do
    it { should be_listening }
  end
end

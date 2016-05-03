def package_arch
  if node['os'] == 'windows' && node['consul']['version'] < '0.6.0'
    '386'
  else
    node['kernel']['machine'] == 'x86_64' ? 'amd64' : '386'
  end
end

def notify_service_restart?
  if node['consul']['notify_restart'] && !node['consul']['disable_service']
    true
  else
    false
  end
end

def consul_sha256sum(version)
  sha256sums = {
    'windows' => {
      '386' => {
        '0.5.2' => '2e866812de16f1a6138a0fd1eebc76143f1314826e3b52597a55ac510ae94be6',
        '0.6.0' => '8379afd07668933c120880bba8228277e380abb14e07a6c45b94562ac19b37bd',
        '0.6.3' => '55733a730c5055d0ed1dc2656b2b6a27b21c7c361a907919cfae90aab2dff870',
        '0.6.4' => '6555f0fff6c3f9ea310c94a73365d9892afc255efb47c85041ad1c0ede854b87'
      },
      'amd64' => {
        '0.6.0' => '182beea0d8d346a9bfd70679621a5542aeeeea1f35be81fa3d3aeec2479bac3d',
        '0.6.3' => '04cd1fdc9cd3a27ffc64e312e40142db7af0d240608f8080ec6d238294b20652',
        '0.6.4' => '1ca3cc2943b27ec8968665efce1122d4ea355ccbde5b4807753af71f11190a9b'
      }
    },
    'linux' => {
      '386' => {
        '0.5.2' => '29306ce398109f954ceeea3af79878be4fb0d949f8af3a27c95ccef2101e8f60',
        '0.6.0' => 'f58f3f03a8b48d89bb8be94a6d1767393ad2a410c920b064066e01c7fa24f06c',
        '0.6.3' => '2afb65383ab913344daaa9af827c1e8576c7cae16e93798048122929b6e4cc92',
        '0.6.4' => 'dbaf5ad1c95aa7dce1625d61b6686d3775e53cb3e7d6c426d29ea96622d248a8'
      },
      'amd64' => {
        '0.5.2' => '171cf4074bfca3b1e46112105738985783f19c47f4408377241b868affa9d445',
        '0.6.0' => '307fa26ae32cb8732aed2b3320ed8daf02c28b50d952cbaae8faf67c79f78847',
        '0.6.3' => 'b0532c61fec4a4f6d130c893fd8954ec007a6ad93effbe283a39224ed237e250',
        '0.6.4' => 'abdf0e1856292468e2c9971420d73b805e93888e006c76324ae39416edcf0627'
      }
    }
  }
  sha256sum = sha256sums[node['os']][package_arch][version]
  raise "sha256sum is missing for consul package version #{version}" unless sha256sum
  sha256sum
end

def webui_sha256sum(version)
  sha256sums = {
    '0.5.2' => 'ad883aa52e1c0136ab1492bbcedad1210235f26d59719fb6de3ef6464f1ff3b1',
    '0.6.0' => '73c5e7ee50bb4a2efe56331d330e6d7dbf46335599c028344ccc4031c0c32eb0',
    '0.6.3' => '93bbb300cacfe8de90fb3bd5ede7d37ae6ce014898edc520b9c96a676b2bbb72',
    '0.6.4' => '5f8841b51e0e3e2eb1f1dc66a47310ae42b0448e77df14c83bb49e0e0d5fa4b7'
  }
  sha256sum = sha256sums[version]
  raise "sha256sum is missing for consul web ui package version #{version}" unless sha256sum
  sha256sum
end

# Module with helper function for filling join and join-wan ip-addresses
module ConsulJoinHelper
  # Function to assist in getting an array of consul server ip addresses in a specific consul dc. Useful to fill the join addresses for a member
  def get_consul_server_ips(excludeself = false, datacenter = node['consul']['config']['datacenter'])
    arrip = []
    if Chef::Config[:solo]
      Chef::Log.warn('This recipe uses search. Chef Solo does not support search.')
    else
      search(
        :node, 'consul_config_server:true AND consul_config_datacenter:\"' + datacenter + '\"',
        :filter_result => { 'ip' => ['ipaddress'] }
      ).each do |result|
        unless excludeself && (result['ip'] == node['ipaddress'])
          arrip.push(result['ip'])
        end
      end
    end
    arrip.uniq.sort!
  end

  # Function to assist in getting an array of consul server ip addresses in an array of consul dc's. Useful to fill the join-wan addresses for servers.
  def get_consul_dc_ips(datacenters = [])
    arrip = []
    datacenters.each do |dc|
      arrip += get_consul_server_ips(false, dc)
    end
    arrip.uniq.sort!
  end
end

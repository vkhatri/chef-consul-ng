def package_arch
  node['kernel']['machine'] == 'x86_64' ? 'amd64' : '386'
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
  sha256sum = sha256sums[package_arch][version]
  fail "sha256sum is missing for consul package version #{version}" unless sha256sum
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
  fail "sha256sum is missing for consul web ui package version #{version}" unless sha256sum
  sha256sum
end

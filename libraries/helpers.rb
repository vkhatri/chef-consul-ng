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
        '0.6.4' => '6555f0fff6c3f9ea310c94a73365d9892afc255efb47c85041ad1c0ede854b87',
        '0.7.0' => 'd0ddfe7d1de9879f02b0d110e45bb74cd5028a2910bcac8b2629d0659367cd96',
        '0.7.1' => 'ad7b76ac8660c7417bbdccbe1905942fa2fcc4c53a093d7b2d64497bdf4fc315',
        '0.7.2' => 'c041dc43995df3505d9146e3a2f532bfc491c49fb644bd1e2ceead7d7dc3011c',
        '0.7.3' => '87a7169bd5298e179a3bbd2f30b3447c09023dc771c97d083779090655bf0a5f',
        '0.7.4' => 'ede957f736758a40fb8e3e33eb423a71226db46085fe1507d880a0ce393e9658',
        '0.7.5' => '7ea88aa53026cb14bab6a68d5b64c43515ea39552594ae399978fc13bcd74707',
        '0.8.0' => '0cb35d7a6861e1a0c0150c3baabcf8a3af8d4890f19d0277b1919f3716ab3501',
        '0.8.1' => '175b63438846fbf800394d00cba1f966c16e967c3ebbf99cf8f3df8fa14ca84f',
        '0.8.2' => '98d840c42e255e1d6011e601bcb1a86b0133e381ce836b4d97e92d9d3c882c8b',
        '0.8.3' => 'c9a6f92b34eab0ceec854830af4c906339737c0df0f4875c03da9ac7031fe56e',
        '0.8.4' => '419d81b6ec7c1f94f495a43becdca7243b33ca9168d6107e3475d5e7c5392f48',
        '0.8.5' => '13b42f20bed1028deec9e272698b65866e187fe26b13b2735f0238b37a1d44b5',
        '0.9.0' => '2ec01564ab08d213169caa1a8e2beb329f7f45339d43e231e0f2b77159568f3c',
        '0.9.1' => '047117cc205b4541162177684fc1b0f1e6f62b7cae7ea0a3c17ce85afd82df97',
        '0.9.2' => 'cdeca9c765e6f43543b229c95c5376b9d60c8ab3b1a790ba94b80cfa1b41ffd5',
        '0.9.3' => '2596b26b084b7a91ca1c165419fe81af5058e82bc1f88bffe23402e61813cdbe',
        '1.0.0' => 'b7415bb29eb56289b6bfa1a39638f55ba88fb443482d1c98ba79e86222f0b5c7',
        '1.0.1' => '04485d94a9e12b88adb94edf6a774ae0837bbb1d6b8166c5b3bb0630c8aa0c0d',
        '1.0.2' => '64cd54847178ffe6447a10dd5839e06567c3c6f6e402c514265880f77f28760c',
        '1.0.3' => '1beb71cf1da5563d1dc05beb309b6a3bb2a884733bf8f9a9c3a851d148691712',
        '1.0.5' => 'b60609be51d53433a08f58e9f177fabd39af30b043462930abc73fb373b2fcec',
        '1.0.6' => 'fc1f08a860a63e94f7edcd763b6773ec8f5f815f03b10806363879f24eb2c2e0',
        '1.0.7' => '654edce5b73a85db4e55d8cf9ccacff2750685b4b160e31afc226f43d8a2ef4d',
        '1.1.0' => '793c8645ebeb86058435427e99b46a7f1693c2e0d75361342a6b69ea51d9a029'
      },
      'amd64' => {
        '0.6.0' => '182beea0d8d346a9bfd70679621a5542aeeeea1f35be81fa3d3aeec2479bac3d',
        '0.6.3' => '04cd1fdc9cd3a27ffc64e312e40142db7af0d240608f8080ec6d238294b20652',
        '0.6.4' => '1ca3cc2943b27ec8968665efce1122d4ea355ccbde5b4807753af71f11190a9b',
        '0.7.0' => 'ac5973a58dd9c6f52c784a7106a29adcf7c94015036538155b6c0ee7efc3a330',
        '0.7.1' => '71a4e073cbab336c0becb5c17a0173fdae56480558564138353dc0b89e989d82',
        '0.7.2' => '7a5ec31018328a3764f22327c940765c9cd99e57c6759fc43fbfed8318d5e379',
        '0.7.3' => 'ec80a931603bf585704e338e6cb497af9aa58ebdae5e3442a3f78f7027d80b66',
        '0.7.4' => 'c2e071ebae166d4cfdf894966b2966026cf9175d394001704f68bcbccaa8e446',
        '0.7.5' => '6cc64b1bb949f926d403e0436d02bf740844cf268076cf6d3d345361c1aa5293',
        '0.8.0' => '0fe04788115908f06534dd27f7ac2dac367e2eec23b632e73842e5cfacf4db46',
        '0.8.1' => 'ea5475b9421dc93383480c622936203eb1b457ff6c96a11e10d65f1aaa061bff',
        '0.8.2' => 'e3def6d26c26937a5c33327ff2884322aa12bdd29235335d877864e05a12fb52',
        '0.8.3' => '9fea45cbe7e55bb94b3d7fb4c8f0527ba36c79029eb1369ace0d45d9546d158a',
        '0.8.4' => 'd320721e5e65bbf96d83feeb7f7dead5b498ff21771e31ea4553adb11299b4fa',
        '0.8.5' => '9ccccea7ecbbfedbceb0a6a0e4bbf3c07bcac14334c69faac42e5a9026471161',
        '0.9.0' => 'c2bd9906b61290fa01ac236393cbfe2f3aadeec4b9ceee724c99217ccb1061ff',
        '0.9.1' => '74bc3b131411fbcdc650542b94daa28838619c086617ab75c78504eef507e781',
        '0.9.2' => '1126fc9841e295dfbdf0d4180336452545eee75b3f545d1c6a105ae8a8020a3c',
        '0.9.3' => '7aaf4d944f77f1f4f9efee0b5e2f28fbd89a83f3fc65ee5dd68a998d6ecda08e',
        '1.0.0' => '3b65661d4cd0336f8c15b0edee483235c7d2025c987e95164ce7fa77ded3e16d',
        '1.0.1' => 'dd09a5d9761f6d96042658ce30f6c0517860fdb5fd463b0c933dda2c2a9d1712',
        '1.0.2' => '4058901d1bd152fa17c380823e78634547d766ebd0414da6daa9357c3cea6ae8',
        '1.0.3' => '287581af4f30a19921bb6c3c4d80282dddae7e8ccced135366af83358e3f62a5',
        '1.0.5' => '2b16d12b32bb37b373f955d17f9cac606505a6391d87532a4dd81024f03b70bc',
        '1.0.6' => '33b95f2cf7387deac27d9f78b768b376919770fc5cc61b9437524f1a1a608c8a',
        '1.0.7' => 'a059c942420ef0e782a80a1914dcc9a4752dad75748460d139c54a6fefba5863',
        '1.1.0' => '24ee62353daf2dd446d1aa8daf6ff0c391d24b1725140ce21b5cc98bb551254d'
      }
    },
    'linux' => {
      '386' => {
        '0.5.2' => '29306ce398109f954ceeea3af79878be4fb0d949f8af3a27c95ccef2101e8f60',
        '0.6.0' => 'f58f3f03a8b48d89bb8be94a6d1767393ad2a410c920b064066e01c7fa24f06c',
        '0.6.3' => '2afb65383ab913344daaa9af827c1e8576c7cae16e93798048122929b6e4cc92',
        '0.6.4' => 'dbaf5ad1c95aa7dce1625d61b6686d3775e53cb3e7d6c426d29ea96622d248a8',
        '0.7.0' => 'babf618b1f10455b4ab65b91bdf5d5a7be5bfbb874ce41e8051caca884c43378',
        '0.7.1' => '7a391a9adc251a5889405eab5512668b77e6ac0f7d818852928735fa82e8abad',
        '0.7.2' => '43b22bcd04e74445c3ea6c143b3acbfe5546d6792c28d123ef5832cd8f96162f',
        '0.7.3' => 'b15e96a1b5833b08d785d67b8f2465a9a0185e34149855943717dd818b347750',
        '0.7.4' => '7fe40af0825b2c6ab6c7e4e3e7d68471cccbd54f9a1513ad622b832cfda5fa07',
        '0.7.5' => '8abf0189776ecc5c8746e12021b6cfe6d96e0b4689ce4a4948b7e3faa07f3025',
        '0.8.0' => 'f07dc0a13b5b1f7832c74558a47ef917d0af1d80063a94bbbebd4ae659f9c6d6',
        '0.8.1' => '76b4a6a39a3299ceb9228bc5e37a6b8a968dc2635a9d72030a047ccff0388886',
        '0.8.2' => 'f60237e24e4f03d8f7fd8a4e31cb246c701c41beb7cb7d1735320a5aa0b331c8',
        '0.8.3' => 'f4c6cdf82de7aacbac1590d46f755ddb4861894cc78753a9b29ef351abaa748c',
        '0.8.4' => 'e58abbfedc4bebb66476448ec0fccda37be1c911c05017d7cd597db6384cd531',
        '0.8.5' => 'b1a7c51834178e1cdc38e7377789c23452b77e1861cfedfc2601fa78e914e46d',
        '0.9.0' => '7f4c537ef333ed93d934b7e0bdb3b16949ae50f4071df16894530e24b9e9d927',
        '0.9.1' => '5143f419b4ba67b6c4fdd023a26a6563f0a7cf47909e648e490ef552caf03f65',
        '0.9.2' => '966b5ae4f149aa1982b037fb5343f4c43f6167b64d09fd01cbd0b5aa13db421a',
        '0.9.3' => 'a39eb7e844cbd5daff04f7aff88c18daa1db7a555d476b1475904bc5f5c7036d',
        '1.0.0' => 'da0642f2d68957d33b67c7ec4ede4d17ead3d4551fc562322a190a98a6f6dceb',
        '1.0.1' => '32c453dc3635922bb955e2058b6de11c184e0e9966b1865f85c700a2cf104f1e',
        '1.0.2' => 'f285cb606d22c7bc2a1115eeb8ce8367d13d755c1ca973d547c29f5c36ac0012',
        '1.0.3' => 'f44d255d5a5126f95698cebc561a76f0824e9b53d391f84d0501d8ef36facbae',
        '1.0.5' => 'dee74b6be36c4b072103e596f354f13848c5bc2946121c1f399f71aa98b12d5d',
        '1.0.6' => '0bfc2b102e3b20bb389e8153bb7e82be2eda2830a0e94b21d63c79d84be08198',
        '1.0.7' => '976eb23dea48c998efa5481f800e0252c948d9c20ca01b90df55e4399b1d6fce',
        '1.1.0' => '1242eb1ebe4cf6e560c74ea746c22b2140ef62bdeebb0e774662fffac266ae75'
      },
      'amd64' => {
        '0.5.2' => '171cf4074bfca3b1e46112105738985783f19c47f4408377241b868affa9d445',
        '0.6.0' => '307fa26ae32cb8732aed2b3320ed8daf02c28b50d952cbaae8faf67c79f78847',
        '0.6.3' => 'b0532c61fec4a4f6d130c893fd8954ec007a6ad93effbe283a39224ed237e250',
        '0.6.4' => 'abdf0e1856292468e2c9971420d73b805e93888e006c76324ae39416edcf0627',
        '0.7.0' => 'b350591af10d7d23514ebaa0565638539900cdb3aaa048f077217c4c46653dd8',
        '0.7.1' => '5dbfc555352bded8a39c7a8bf28b5d7cf47dec493bc0496e21603c84dfe41b4b',
        '0.7.2' => 'aa97f4e5a552d986b2a36d48fdc3a4a909463e7de5f726f3c5a89b8a1be74a58',
        '0.7.3' => '901a3796b645c3ce3853d5160080217a10ad8d9bd8356d0b73fcd6bc078b7f82',
        '0.7.4' => '23a61773bee9b29198cc1f8fe2e62c320f82f95006ff70840c15c1e58eead73b',
        '0.7.5' => '40ce7175535551882ecdff21fdd276cef6eaab96be8a8260e0599fadb6f1f5b8',
        '0.8.0' => 'f4051c2cab9220be3c0ca22054ee4233f1396c7138ffd97a38ffbcea44377f47',
        '0.8.1' => '74cdd7ad458aa63192222ad2bd14178fc3596d4fd64d12a80520d4e6f93eaf34',
        '0.8.2' => '6409336d15baea0b9f60abfcf7c28f7db264ba83499aa8e7f608fb0e273514d9',
        '0.8.3' => 'f894383eee730fcb2c5936748cc019d83b220321efd0e790dae9a3266f5d443a',
        '0.8.4' => 'c8859a0a34c50115cdff147f998b2b63226f5f052e50f342209142420d1c2668',
        '0.8.5' => '35dc317c80862c306ea5b1d9bc93709483287f992fd0797d214d1cc1848e7b62',
        '0.9.0' => '33e54c7d9a93a8ce90fc87f74c7f787068b7a62092b7c55a945eea9939e8577f',
        '0.9.1' => 'e997b87e70dc0f4996d7c5ac89f4776a8569ca99c00e5c8b8a0e0eb1042a9d30',
        '0.9.2' => '0a2921fc7ca7e4702ef659996476310879e50aeeecb5a205adfdbe7bd8524013',
        '0.9.3' => '9c6d652d772478d9ff44b6decdd87d980ae7e6f0167ad0f7bd408de32482f632',
        '1.0.0' => '585782e1fb25a2096e1776e2da206866b1d9e1f10b71317e682e03125f22f479',
        '1.0.1' => 'eac5755a1d19e4b93f6ce30caaf7b3bd8add4557b143890b1c07f5614a667a68',
        '1.0.2' => '418329f0f4fc3f18ef08674537b576e57df3f3026f258794b4b4b611beae6c9b',
        '1.0.3' => '4782e4662de8effe49e97c50b1a1233c03c0026881f6c004144cc3b73f446ec5',
        '1.0.5' => '0c6db793e49566f839249c5fb58a2262fb79d16a01bc5d41d78c89982760d71f',
        '1.0.6' => 'bcc504f658cef2944d1cd703eda90045e084a15752d23c038400cf98c716ea01',
        '1.0.7' => '6c2c8f6f5f91dcff845f1b2ce8a29bd230c11397c448ce85aae6dacd68aa4c14',
        '1.1.0' => '09c40c8b5be868003810064916d8460bff334ccfb59a5046390224b27e052c45'
      },
      'arm' => {
        '0.7.1' => 'e7b6846fb338c31e238f9b70cc42bd35f7de804cc31d2d91fe23cbe5de948aae',
        '0.7.2' => 'e18934a3a38b980bc0cfaa8d74379a6bfe58cf1ecf4b164e28ff37dd6c7198b0',
        '0.7.3' => 'a2d2d2cf194e3768aae7c3cdf140a056bf2534f4c83fb7a66cfbd4090c98773e',
        '0.7.4' => 'bfd9cbef9c7c9f2128704940323d1727d8edbbd595c8d82aba923e04f04b266d',
        '0.7.5' => 'df4bc38eff4305632d29c5650fbb7e7ff97b8ef12a964fd8ee5f691849c51711',
        '0.8.0' => 'a6efaabb11990672df0aaf6c70a272484d2f6d654f393c58ec1a41fd30629f0c',
        '0.8.1' => '552aa077ffbe6a52bf38d8feca5803a813a7a3986e4cb6efda61dad4480642c1',
        '0.8.2' => '02b63410a8c46bab0713615c126eb1530945ebfac3340bcb748d12cb1ab6db8c',
        '0.8.3' => 'a650c9a973fb34c23328f717a6bd5fe6bc22ac3b9e15013649c720d87dce90d4',
        '0.8.4' => 'ce9914f75df068930fc78cb99ddcad7e4c298a385a5fa3686b2d9d4ea1044945',
        '0.8.5' => '59d14c76f808a1d41647e2d772ce1fe0d4a522836af238faa4894f7e076b1b03',
        '0.9.0' => '35a35db51af51cfbdf6ee67e3d0311c7823cfe17a55f0babccb0d58ee6a344ff',
        '0.9.1' => '393347d27cfc9362b17c92099296f09acfc7ac2b7671b05350d1aa960dd85086',
        '0.9.2' => '15c556b1b66d3fe80837898c85628e7ee5eadcb3a86cb4814a4eda072e6d7c29',
        '0.9.3' => '068c9c20f15fe348e9ac36081e0c87d12fcc650c60638ea3f87e299b24b1cd6a',
        '1.0.0' => '34824f09909c71542e6b44a19e4c76627d341caf8a40e158c8b4d18aa5039a29',
        '1.0.1' => 'e4cd79302b1506e082a9e79b77d66249a4f87be4ffe42268cb922d15adb7d0d0',
        '1.0.2' => 'a54c3b093078c21affa2eb7a6100d1601c3dd9001b5ff8225a8fdb3fe87f6c6b',
        '1.0.3' => '3e0e5fb025bda9d45aed39945fea0044a371ce2a09e31434e78442d211dd89e7',
        '1.0.5' => '725b33c652fc275ee7927618b4b652fd9a760ef49ae52065fbe8099c897eb588',
        '1.0.6' => 'e9e5569eaaa3ef99d127af282a67115b121e23f4653e97db95f9bdafe71f63e8',
        '1.0.7' => '126c75ad6582cb3db31e75c980ea6ba2161c23e4c9d180538bd45d8209649f84',
        '1.1.0' => '498f5677a3267222c0ade3b4930370a0fd7e9422716c675f6a92b54eb2947d8d'
      }
    }
  }
  sha256sum = node['consul']['sha256sum_override'] ? node['consul']['sha256sum_override'] : sha256sums[node['os']][package_arch][version]
  raise "sha256sum is missing for consul package version #{version}" unless sha256sum
  sha256sum
end

def webui_sha256sum(version)
  sha256sums = {
    '0.5.2' => 'ad883aa52e1c0136ab1492bbcedad1210235f26d59719fb6de3ef6464f1ff3b1',
    '0.6.0' => '73c5e7ee50bb4a2efe56331d330e6d7dbf46335599c028344ccc4031c0c32eb0',
    '0.6.3' => '93bbb300cacfe8de90fb3bd5ede7d37ae6ce014898edc520b9c96a676b2bbb72',
    '0.6.4' => '5f8841b51e0e3e2eb1f1dc66a47310ae42b0448e77df14c83bb49e0e0d5fa4b7',
    '0.7.0' => '42212089c228a73a0881a5835079c8df58a4f31b5060a3b4ffd4c2497abe3aa8',
    '0.7.1' => '1b793c60e1af24cc470421d0411e13748f451b51d8a6ed5fcabc8d00bfb84264',
    '0.7.2' => 'c9d2a6e1d1bb6243e5fd23338d92f5c71cdf0a4077f7fcc95fd81800fa1f42a9',
    '0.7.3' => '52b1bb09b38eec522f6ecc0b9bf686745bbdc9d845be02bd37bf4b835b0a736e',
    '0.7.4' => '3d2ef4035b53dc448c8b2db7835e96d3d0365a2577f5a0b316c8dfc726f34a64',
    '0.7.5' => 'a7803e7ba2872035a7e1db35c8a2186ad238bf0f90eb441ee4663a872b598af4',
    '0.8.0' => '1d576da825b18a42d2c28b2cfe2572bdb3c4ec39c63fbf3ec17c4d6a794bc2b4',
    '0.8.1' => '0caff8d54a80ff7bc5baec39b0eda19a9652df992db324026e361fa31183749f',
    '0.8.2' => '81e6da2e679c0235ef42c6f4054045603e12e51850d979cba9c2d4fe06723131',
    '0.8.3' => '9212c44c3ee4acaeca88d794225a2858a558be531a3cd44c741990c4493d6f12',
    '0.8.4' => '7a49924a872205002b2bf72af8c82d5560d4a7f4a58b2f65ee284dd254ebd063',
    '0.8.5' => '4f7b90d8159480daeff6f3673f56fc75c00e4fd05de9c5c6d22a4af2fbc78368'
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
        :node, "consul_config_server:true AND consul_config_datacenter:#{datacenter}",
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

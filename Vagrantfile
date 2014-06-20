Vagrant::configure('2') do |config|
  # the base box this environment is built off of
  config.vm.box = 'trusty32'

  # the url from where to fetch the base box if it doesn't exist
  config.vm.box_url = 'https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-i386-vagrant-disk1.box'

  # configure network
  config.vm.hostname = 'gere.mwu.dk'
  config.vm.network :private_network, ip: '33.33.33.10'

  # configure memory limit and node name
  config.vm.provider 'virtualbox' do |v|
    v.name = 'Vagrant: Gere'
    v.customize ['modifyvm', :id, '--memory', 256]
  end

  # use puppet to provision packages
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'puppet/manifests'
    puppet.manifest_file = 'site.pp'
    puppet.module_path = 'puppet/modules'
    puppet.options = "--hiera_config /vagrant/hiera.yaml"
  end
end

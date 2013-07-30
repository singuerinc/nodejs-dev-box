Vagrant.configure("2") do |config|

  config.vm.box = 'precise32'
  config.vm.box_url = 'http://files.vagrantup.com/precise32.box'

  config.vm.network :private_network, ip: "10.11.12.13"
  config.vm.network :forwarded_port, guest: 9292, host: 9292

  config.vm.synced_folder ".", "/vagrant", :nfs => true

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'vagrant/manifests'
    puppet.manifest_file  = 'base.pp'
  end

end

# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
    config.vm.box = "vStone/centos-7.x-puppet.3.x"
#    config.vm.box_url = 'http://packages.vstone.eu/vagrant-boxes/centos-6.3-64bit-latest.box'
    config.vm.hostname = 'sentry.example.org'

  # config.vm.box_check_update = false

  config.vm.network "forwarded_port", guest: 80, host: 8080
  #config.vm.network "forwarded_port", guest: 443, host: 8443
  # config.vm.network "forwarded_port", guest: 7071, host: 7071

    config.ssh.forward_agent = true

    config.vm.provider "virtualbox" do |vb|
         vb.gui = false

         vb.customize ["modifyvm", :id, "--memory", "3192"]
    end
   
    config.vm.synced_folder "downloads/", "/tmp/downloads/", create: true, mount_options: ['ro']


    config.vm.provision "puppet" do |puppet|
        puppet.manifests_path = "provision/manifests"
        puppet.manifest_file  = "site.pp"
        puppet.module_path = ['provision/modules']
        puppet.hiera_config_path = 'provision/hiera/00_hiera_config.yaml'
        puppet.working_directory = "/vagrant"
        puppet.options = "--verbose --pluginsync"

    end

end


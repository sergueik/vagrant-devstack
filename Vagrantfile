# -*- mode: ruby -*-
# vi: set ft=ruby :

DEVSTACK_IP = ENV['DEVSTACK_IP'] || '192.168.50.10'
basedir =  ENV.fetch('USERPROFILE', '')  
basedir  = ENV.fetch('HOME', '') if basedir == ''
basedir = basedir.gsub('\\', '/')

Vagrant.configure('2') do |config|

  config.vm.box = 'trusty'
  config.vm.box_url = "file://#{basedir}/Downloads/trusty-server-cloudimg-amd64-vagrant-disk1.box"
  # cached ubuntu 12.04 LTS image 'http://cloud-images.ubuntu.com/vagrant/precise/current/precise-server-cloudimg-amd64-vagrant-disk1.box'

  config.vm.hostname = 'devstack'

  # devstack needs more than 1024 MB memory
  config.vm.provider 'virtualbox' do |p|
    p.customize ['modifyvm', :id, '--memory', '2048']
  end

  # forward open stack ui
  # config.vm.network :forwarded_port, guest: 80, host: 8080

  # private network setup
  config.vm.network :private_network, ip: DEVSTACK_IP

  # resolve "stdin: is not a tty warning", related issue and proposed fix: https://github.com/mitchellh/vagrant/issues/1673
  config.ssh.shell = "bash -c 'BASH_ENV=/etc/profile exec bash'"

  # install devstack
  config.vm.provision :shell, :inline => <<EOF
export OS_USER=vagrant
export OS_HOST_IP=#{DEVSTACK_IP}
# run script
sh /vagrant/devstack.sh

EOF

end

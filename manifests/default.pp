# Update to the latest software
exec { "yum update -y":
  path => "/usr/bin",
}

# Install RabbitMQ
package { 'postgresql-server.x86_64': ensure  => 'latest' }
package { 'wget': ensure  => 'latest' }
package { 'curl': ensure  => 'latest' }

# Get PIP install script
exec { "get-pip":
  command => "/usr/bin/curl -k https://bootstrap.pypa.io/get-pip.py --output /home/vagrant/get-pip.py",
  path => "/vagrant",
}

# Install Pip library for python modules
exec { "install-pip":
  command => "/usr/bin/python /vagrant/get-pip.py",
  path => "/vagrant",
  require => Exec["get-pip"]
}

exec { "get-meter-install":
  command => "/usr/bin/curl -k https://raw.githubusercontent.com/boundary/boundary_scripts/master/setup_meter.sh -o /home/vagrant/setup_meter.sh",
  path => "/vagrant",
  require => Package[curl]
}

file { "setup":
  path => "/home/vagrant/setup_meter.sh",
  ensure => 'present',
  owner => "vagrant",
  group => "vagrant",
  mode   => 755,
  require => Exec["get-meter-install"]
}

#
# Relay
#

# Install the relay
#exec { "install-relay":
#  command => "/usr/bin/sudo /usr/bin/npm install graphdat-relay -g",
#  path => "/vagrant",
#  require => Package[nodejs,npm]
#}

#file { "graphdat-initd":
#  path => "/etc/init.d/graphdat-relay",
#  owner => "root",
#  group => "root",
#  mode   => 755,
#  source => '/vagrant/graphdat-relay',
#}

# Create directory for the relay
#file { "graphdat-dir":
#    path   => "/etc/graphdat-relay",
#    ensure => "directory",
#    owner  => "root",
#    group  => "root",
#    mode   => 755,
#}

file { 'profile':
path => '/home/vagrant/.bash_profile',
mode => 0400,
owner => vagrant,
group => vagrant,
source => '/vagrant/bash_profile',
require => Package[rabbitmq-server]
}

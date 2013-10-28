Exec {
  path => ['/usr/sbin', '/usr/bin', '/sbin', '/bin']
}

# --- Preinstall Stage ---------------------------------------------------------

stage { 'preinstall':
  before => Stage['main']
}

class apt_get_update {
  exec { 'apt-get -y update':

  }
}
class { 'apt_get_update':
  stage => preinstall
}

# --- Packages -----------------------------------------------------------------

package { 'curl':
  ensure => installed
}

package { 'build-essential':
  ensure => installed
}

package { 'git-core':
  ensure => installed
}

package { 'vim':
  ensure => installed
}

package { 'mongodb':
  ensure => installed
}

package { 'nodejs':
  ensure => installed
}

class install_fish {

  exec { 'install_libjs_jquery':
    command => "sudo apt-get -y install libjs-jquery",
    unless => "test -e /usr/bin/fish"
  }

    exec { 'install_bc':
    command => "sudo apt-get -y install bc",
    unless => "test -e /usr/bin/fish",
    require => Exec['install_libjs_jquery']
  }

  exec { 'download_fish':
    command => "wget http://fishshell.com/files/2.1.0/linux/Ubuntu/fish_2.1.0-1~precise_i386.deb",
    unless => "test -e /usr/bin/fish",
    require => Exec['install_bc']
  }

  exec { 'install_fish':
    command => "sudo dpkg -i fish_2.1.0-1~precise_i386.deb",
    unless => "test -e /usr/bin/fish",
    require => Exec['download_fish']
  }

  file {['/home/vagrant/.config', '/home/vagrant/.config/fish']:
    ensure  => directory,
    require => Exec['install_fish']
  }

  file {'/home/vagrant/.config/fish/config.fish':
    ensure  => file,
    content => 'set -g -x PATH /usr/local/bin $PATH',
    require => File['/home/vagrant/.config/fish']
  }

  exec { 'change_shell_to_fish':
    command => "chsh -s /usr/bin/fish"
  }
}

class { 'install_fish': }

class install_nodejs {
  exec { 'install_python_soft_properties':
    command => "sudo bash -c 'apt-get -y install python-software-properties python g++ make'",
    unless => "test -e /usr/bin/nodejs"
  }

  exec { 'add_nodejs_alt_repo':
    command => "sudo add-apt-repository ppa:chris-lea/node.js",
    require => Exec['install_python_soft_properties'],
    unless => "test -e /usr/bin/nodejs"
  }

  exec { 'apt_get_update2':
    command => "sudo apt-get -y update",
    require => Exec['add_nodejs_alt_repo'],
    unless => "test -e /usr/bin/nodejs"
  }

  exec { 'install_nodejs':
    command => "sudo apt-get -y install nodejs",
    require => Exec['apt_get_update2'],
    unless => "test -e /usr/bin/nodejs"
  }

  exec { 'install_nodemon':
    command => "sudo npm install -g nodemon",
    require => Exec['install_nodejs'],
    unless => "test -e /usr/bin/nodemon"
  }

  exec { 'install_express':
    command => "sudo npm install -g express",
    require => Exec['install_nodejs'],
    unless => "test -e /usr/bin/express"
  }
}

class { 'install_nodejs': }
# PACKAGES
default['docker']['version'] = '1.12.2'
default['docker']['repo'] = 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
default['docker']['apt']['install_packages'] =  %w{ apt-transport-https ca-certificates}
default['docker']['apt']['purge_packages'] =  %w{  }

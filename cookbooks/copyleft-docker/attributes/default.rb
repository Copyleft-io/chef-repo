# PACKAGES
default['docker']['version'] = '1.8.3'
default['docker']['repo'] = 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'
default['docker']['apt']['install_packages'] =  %w{ apt-transport-https ca-certificates}
default['docker']['apt']['purge_packages'] =  %w{  }

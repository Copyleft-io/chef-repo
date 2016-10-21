#
# Cookbook Name:: copyleft-docker
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
#
# REF: https://docs.docker.com/engine/installation/linux/ubuntulinux/

# ADD DOCKER REPO
execute 'add_docker_repo' do
  user 'root'
  command 'echo "deb https://apt.dockerproject.org/repo ubuntu-xenial main" > /etc/apt/sources.list.d/docker.list'
  not_if { File.exists?('/etc/apt/sources.list.d/docker.list') }
  notifies :run, 'execute[update_package_index]', :immediately
  notifies :run, 'execute[add_gpg_key]', :immediately
end

# UPDATE THE PACKAGE INDEX
execute 'update_package_index' do
  user 'root'
  command 'apt-get update'
  action :nothing
end

# Ensure that APT works with the https method
# and that CA certificates are installed.
# INSTALL Required Packages
node['docker']['apt']['install_packages'].each do |name|
  package name do
    action :install
  end
end

# ADD NEW GPG KEY
execute 'add_gpg_key' do
  user 'root'
  command 'apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D'
  action :nothing
end

# For Ubuntu Trusty, and Xenial, it’s recommended to install the
# linux-image-extra-* kernel packages. The linux-image-extra-* packages allows
# you use the aufs storage driver.
execute 'install_kernel_packages' do
  user 'root'
  command 'apt-get -y install linux-image-extra-$(uname -r) linux-image-extra-virtual'
  not_if { File.exists?('/var/chef/versions/docker.version') }
end

# UPGRADE TO PULL IN THE DOCKER PACKAGE FROM THE NEW REPO
# TO VERIFY THIS MANUALLY apt-cache policy docker-engine
# execute 'upgrade_package_docker' do
#   user 'root'
#   command 'apt-get -y upgrade'
#   not_if { File.exists?('/var/chef/versions/docker.version') }
# end

# INSTALL DOCKER
package 'docker-engine' do
  action :install
end

# ENABLE, START DOCKER SERVICE
service 'docker' do
  action [:enable, :start]
end

# CREATE VERSION FILE
execute 'create_version_file' do
  user 'root'
  command 'echo "DOCKER VERSION <todo> > /var/chef/versions/docker.version'
  not_if { File.exists?('/var/chef/versions/docker.version') }
end

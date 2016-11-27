# The docker_installation_package resource uses the system package manager to
# install Docker. It relies on the pre-configuration of the system's package
# repositories. The chef-yum-docker and chef-apt-docker Supermarket cookbooks
# are used to do this in test-kitchen.
#
# This is the recommended production installation method.

# ADD DOCKER REPO
execute 'add_docker_repo' do
  user 'root'
  command "echo #{node['docker']['repo']} > /etc/apt/sources.list.d/docker.list"
  not_if { File.exists?('/etc/apt/sources.list.d/docker.list') }
  notifies :run, 'execute[update_package_index]', :immediately
  notifies :run, 'execute[add_gpg_key]', :immediately
end

# ADD NEW GPG KEY
execute 'add_gpg_key' do
  user 'root'
  command 'apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D'
  action :nothing
end

# UPDATE THE PACKAGE INDEX
execute 'update_package_index' do
  user 'root'
  command 'apt-get update'
  action :nothing
end

# DOCKER INSTALLATION
docker_installation_package 'default' do
  version "#{node['docker']['version']}"
  action :create
  package_options %q|--force-yes -o Dpkg::Options::='--force-confold' -o Dpkg::Options::='--force-all'| # if Ubuntu for example
end

# ENABLE, START DOCKER SERVICE
service 'docker' do
  action [:enable, :start]
end

# CREATE VERSION FILE
execute 'create_version_file' do
  user 'root'
  command "echo #{node['docker']['version']} > /var/chef/versions/docker.version"
end

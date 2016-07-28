#
# Cookbook Name:: copyleft-sensu
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# PREQUISITES

# INSTALL REDIS SERVER PACKAGE
package 'redis-server'


# CONFIGURE REDIS SERVER TO START ON BOOT
service 'redis-server' do
  action [:enable, :start]
end

directory '/etc/sensu/conf.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  recursive true
end

# CONFIGURE SENSU FOR REDIS
cookbook_file '/etc/sensu/conf.d/redis.json' do
  source 'redis.json'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

#INSTALL ERLANG THE RABBITMQ RUNTIME
package 'rabbitmq-server'

# CONFIGURE RABBITMQ SERVER TO START ON BOOT
service 'rabbitmq-server' do
  action [:enable, :start]
end

execute 'create_rabbitmq_vhost_for_sensu' do
  user 'root'
  command <<-EOH
    rabbitmqctl add_vhost /sensu
    rabbitmqctl add_user sensu secret
    rabbitmqctl set_permissions -p /sensu sensu ".*" ".*" ".*"
  EOH
  not_if { File.exists?("/etc/sensu/conf.d/rabbitmq.json") }
end

# CONFIGURE SENSU FOR RABBITMQ
cookbook_file '/etc/sensu/conf.d/rabbitmq.json' do
  source 'redis.json'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# CONFIGURE SENSU
cookbook_file '/etc/sensu/config.json' do
  source 'config.json'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# INSTALL SENSU
# Once we have installed Sensu’s prerequisites (RabbitMQ and/or Redis),
# we are ready to install a Sensu Server and API.

# Sensu Core is installed via native system installer package formats
# (e.g. .deb, .rpm, .msi, .pkg, etc), which are available for download from
# the Sensu Downloads page, and from package manager repositories for APT
# (for Ubuntu/Debian systems), and YUM (for RHEL/CentOS).

# The Sensu Core packages installs several processes, including sensu-server,
# sensu-api, and sensu-client.

execute 'install_sensu_public_key' do
  user 'root'
  command <<-EOH
    wget -q http://sensu.global.ssl.fastly.net/apt/pubkey.gpg -O- | sudo apt-key add -
  EOH
  not_if { File.exists?("/etc/sensu/conf.d/rabbitmq.json") }
end

execute 'create_sensu_apt_config_file' do
  user 'root'
  command <<-EOH
    echo "deb     http://sensu.global.ssl.fastly.net/apt sensu main" | tee /etc/apt/sources.list.d/sensu.list
    apt-get update
    apt-get --yes --allow-unauthenticated install sensu
  EOH
  not_if { File.exists?("/opt/sensu") }
end

# CONFIGURE SENSU SERVICES TO START ON BOOT
service 'sensu-client' do
  action [:enable, :start]
end

service 'sensu-server' do
  action [:enable, :start]
end

service 'sensu-api' do
  action [:enable, :start]
end

include_recipe 'copyleft-sensu::uchiwa'

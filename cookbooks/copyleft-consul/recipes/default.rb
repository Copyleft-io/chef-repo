#
# Cookbook Name:: copyleft-consul
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# CREATE OPT/ZEUS/DEPLOY/CONSUL DIRECTORY
# This is our default location where applications will be installed
directory '/opt/zeus/deploy/consul' do
  owner node['base']['user']
  group node['base']['group']
  mode '0755'
  action :create
end

# GET ZIP DOWNLOAD
remote_file '/opt/zeus/deploy/consul/consul.zip' do
  source 'https://releases.hashicorp.com/consul/0.7.0/consul_0.7.0_linux_amd64.zip'
  owner node['base']['user']
  group node['base']['group']
  mode '0755'
  action :create
  notifies :run, 'execute[unzip_consul_artifact]', :immediately
end

# EXTRACT ZIP
execute 'unzip_consul_artifact' do
  user 'root'
  cwd '/usr/bin'
  command 'unzip /opt/zeus/deploy/consul/consul.zip'
  action :nothing
end

# CREATE DIRECTORY STRUCTURE
# CONSUL CONFIGURATION DIRECTORY
directory '/etc/consul.d' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# CONSUL DATA DIRECTORY
directory '/opt/consul' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

# CONSUL LOG DIRECTORY
directory '/var/log/consul' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

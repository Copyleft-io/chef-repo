#
# Cookbook Name:: copyleft-base
# Recipe:: base
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# CREATE DEFAULT USER
# IF YOU'RE GOING TO TRY AND RULE THE CLOUD, MIGHT AS WELL INVITE ZEUS ;^)

# CREATE THE ZEUS GROUP
group node['base']['group'] do
  action :create
  not_if "getent group #{node.base.group}"
end

# CREATE THE ZEUS USER
user node['base']['user'] do
  comment ''
  gid node['base']['group']
  home node['base']['directory']
  shell '/bin/bash'
  password node['base']['password']
  action :create
  not_if "getent passwd #{node.base.user}"
end

# CREATE OPT/ZEUS DIRECTORY
# This is our default location where applications will be installed
directory node['base']['directory'] do
  owner node['base']['user']
  group node['base']['group']
  mode '0755'
  action :create
end

# CREATE TMP/DEPLOY DIRECTORY
# This is our default location where downloaded packages
# will be staged for deployment
directory  node['base']['deploy_directory'] do
  owner node['base']['user']
  group node['base']['group']
  mode '0755'
  action :create
end

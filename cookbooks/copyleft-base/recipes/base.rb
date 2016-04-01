#
# Cookbook Name:: copyleft-base
# Recipe:: base
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# CREATE DEFAULT USER
# IF YOU'RE GOING TO TRY AND RULE THE CLOUD, MIGHT AS WELL INVITE ZEUS ;^)
user 'zeus' do
  comment ''
  home '/opt/zeus'
  shell '/bin/bash'
  password 'olympia'
  action :create
end

# CREATE OPT/ZEUS DIRECTORY
# This is our default location where applications will be installed
directory '/opt/zeus' do
  owner 'zeus'
  group 'zeus'
  mode '0755'
  action :create
end

# CREATE TMP/DEPLOY DIRECTORY
# This is our default location where downloaded packages
# will be staged for deployment
directory '/tmp/deploy' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

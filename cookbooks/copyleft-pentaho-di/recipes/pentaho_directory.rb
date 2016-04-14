#
# Cookbook Name:: copyleft-pentaho-di
# Recipe:: pentaho_directory
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

directory "#{node['pentaho']['directory']}/server" do
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  recursive true
  action :create
end

directory "#{node['pentaho']['directory']}/server/data-integration-server" do
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  recursive true
  action :create
end

directory '/opt/zeus/.pentaho' do
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

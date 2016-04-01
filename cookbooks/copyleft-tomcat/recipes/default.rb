#
# Cookbook Name:: copyleft-tomcat
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

#package 'tomcat7'

# INCLUDE COOKBOOK DEPENDENCIES
include_recipe 'copyleft-base'
include_recipe 'copyleft-java'

# RECIPE VARIABLES
tomcat_bin_dir = File.join(node['tomcat']['directory'], "apache-tomcat-#{node['tomcat']['version']}", 'bin')

# # CREATE THE DIRECTORY
# directory node['tomcat']['directory'] do
#   owner node['tomcat']['user']
#   group node['tomcat']['group']
#   mode 00755
#   action :create
# end

# directory node['tomcat']['download_directory'] do
#   owner node['tomcat']['user']
#   group node['tomcat']['group']
#   mode 00755
#   action :create
# end
#
# directory "#{node['tomcat']['directory']}/logs" do
#   owner node['tomcat']['user']
#   group node['tomcat']['group']
#   mode 00755
#   recursive true
#   action :create
# end

file node['tomcat']['app_version_file'] do
  mode 00644
  owner node['tomcat']['user']
  group node['tomcat']['group']
  content node['tomcat']['version']
end

cookbook_file "#{node['tomcat']['deploy_directory']}/apache-tomcat-#{node['tomcat']['version']}.zip" do
  source "apache-tomcat-#{node['tomcat']['version']}.zip"
  owner node['tomcat']['user']
  group node['tomcat']['group']
  mode '0755'
  action :create
end

execute 'unzip_tomcat_zip' do
  user node['tomcat']['user']
  command "unzip #{node['tomcat']['deploy_directory']}/apache-tomcat-#{node['tomcat']['version']}.zip -d #{node['tomcat']['directory']}"
  creates "#{node['tomcat']['directory']}/apache-tomcat-#{node['tomcat']['version']}"
end

link '/opt/zeus/tomcat' do
  to File.join(node['tomcat']['directory'], "apache-tomcat-#{node['tomcat']['version']}")
end

%w( startup.sh killtomcat.sh).each do |bin_file|
  template File.join(tomcat_bin_dir, bin_file) do
    mode 00755
    owner node['tomcat']['user']
    group node['tomcat']['group']
    source "#{bin_file}.erb"
  end
end

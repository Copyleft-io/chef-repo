#
# Cookbook Name:: copyleft-pentaho-di
# Recipe:: pentaho_artifacts
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# STAGE DEPLOYMENT ARTIFACTS
# di-license-installer.zip -> pentaho/
# di-jdbc-distribution-utility.zip -> pentaho/SERVER
# di-pentaho-data.zip -> pentaho/server/data-integration-server
# di-pentaho-solutions.zip -> pentaho/server/data-integration-server
# pentaho-di.war -> Tomcat: pentaho/server/data-integration-server/<your tomcat installation directory>/webapps
# pentaho-style.war -> Tomcat: pentaho/server/data-integration-server/<your tomcat installation directory>/webapps
# PentahoBIPlatform_OSS_Licenses.html -> pentaho/server/data-integration-server

cookbook_file "#{node['pentaho']['deploy_directory']}/Pentaho_PDI_EE.lic" do
  source 'Pentaho_PDI_EE.lic'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

cookbook_file "#{node['pentaho']['deploy_directory']}/di-license-installer.zip" do
  source 'di-license-installer.zip'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

cookbook_file "#{node['pentaho']['deploy_directory']}/di-jdbc-distribution-utility.zip" do
  source 'di-jdbc-distribution-utility.zip'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

cookbook_file "#{node['pentaho']['deploy_directory']}/di-pentaho-data.zip" do
  source 'di-pentaho-data.zip'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

cookbook_file "#{node['pentaho']['deploy_directory']}/di-pentaho-solutions.zip" do
  source 'di-pentaho-solutions.zip'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

cookbook_file "#{node['pentaho']['deploy_directory']}/pentaho-di.war" do
  source 'pentaho-di.war'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

cookbook_file "#{node['pentaho']['deploy_directory']}/pentaho-style.war" do
  source 'pentaho-style.war'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

cookbook_file "#{node['pentaho']['deploy_directory']}/PentahoDataIntegration_OSS_Licenses.html" do
  source 'PentahoDataIntegration_OSS_Licenses.html'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

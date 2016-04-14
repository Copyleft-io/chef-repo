#
# Cookbook Name:: copyleft-pentaho-di
# Recipe:: pentaho_install
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# UNZIP INSTALLATION FILES
# di-license-installer.zip -> pentaho/
# di-jdbc-distribution-utility.zip -> pentaho/SERVER
# di-pentaho-data.zip -> pentaho/server/data-integration-server
# di-pentaho-solutions.zip -> pentaho/server/data-integration-server


execute 'unzip_di_license_installer' do
  user 'root'
  command "unzip #{node['pentaho']['deploy_directory']}/di-license-installer.zip -d #{node['pentaho']['directory']}"
  creates "#{node['pentaho']['directory']}/license-installer"
  notifies :run, 'execute[install_pdi_ee_license]', :delayed
end

execute 'unzip_di_jdbc_distribution_utility' do
  user node['pentaho']['user']
  group node['pentaho']['group']
  command "unzip #{node['pentaho']['deploy_directory']}/di-jdbc-distribution-utility.zip -d #{node['pentaho']['directory']}/server"
  creates "#{node['pentaho']['directory']}/server/jdbc-distribution"
end

execute 'unzip_di_pentaho_data' do
  user node['pentaho']['user']
  group node['pentaho']['group']
  command "unzip #{node['pentaho']['deploy_directory']}/di-pentaho-data.zip -d #{node['pentaho']['directory']}/server/data-integration-server"
  creates "#{node['pentaho']['directory']}/server/data-integration-server/data"
end

execute 'unzip_di_pentaho_solutions' do
  user node['pentaho']['user']
  group node['pentaho']['group']
  command "unzip #{node['pentaho']['deploy_directory']}/di-pentaho-solutions.zip -d #{node['pentaho']['directory']}/server/data-integration-server"
  creates "#{node['pentaho']['directory']}/server/data-integration-server/pentaho-solutions"
end

remote_file "#{node['pentaho']['directory']}/server/data-integration-server/PentahoDataIntegration_OSS_Licenses.html" do
  source "file:///#{node['pentaho']['deploy_directory']}/PentahoDataIntegration_OSS_Licenses.html"
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
  #notifies :run, 'execute[chown_pentaho]', :immediately
end

# execute 'chown_pentaho' do
#   user 'root'
#   command 'chown -R pentaho:pentaho /opt/pentaho'
#   action :nothing
# end

# IMPORTANT NOTE
# If your web application server is not in the pentaho/server/data-integration-server directory,
# the pentaho-di.war and pentaho-style.war files should appear where you've chosen to install
# your web application server.

# pentaho-di.war -> Tomcat: pentaho/server/data-integration-server/<your tomcat installation directory>/webapps
# pentaho-style.war -> Tomcat: pentaho/server/data-integration-server/<your tomcat installation directory>/webapps

remote_file "#{node['pentaho']['tomcat_directory']}/webapps/pentaho-di.war" do
  source "file:///#{node['pentaho']['deploy_directory']}/pentaho-di.war"
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

execute 'unzip_pentaho_di_war' do
  user node['pentaho']['user']
  group node['pentaho']['group']
  command "unzip #{node['pentaho']['tomcat_directory']}/webapps/pentaho-di.war -d #{node['pentaho']['tomcat_directory']}/webapps/pentaho-di"
  creates "#{node['pentaho']['tomcat_directory']}/webapps/pentaho-di"
end

remote_file "#{node['pentaho']['tomcat_directory']}/webapps/pentaho-style.war" do
  source "file:///#{node['pentaho']['deploy_directory']}/pentaho-style.war"
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

execute 'unzip_pentaho_style_war' do
  user node['pentaho']['user']
  group node['pentaho']['group']
  command "unzip #{node['pentaho']['tomcat_directory']}/webapps/pentaho-style.war -d #{node['pentaho']['tomcat_directory']}/webapps/pentaho-style"
  creates "#{node['pentaho']['tomcat_directory']}/webapps/pentaho-style"
end

# SET ENVIRONMENT VARIABLES
# export PENTAHO_JAVA_HOME=/usr/lib/jvm/oracle-7-java
# export PENTAHO_INSTALLED_LICENSE_PATH=/home/pentaho/.pentaho/.installedLicenses.xml
execute 'set_pentaho_java_home' do
  command 'export PENTAHO_JAVA_HOME=/usr/lib/jvm/oracle-7-java'
  #not_if { File.exists?('/opt/pentaho/server/data-integration-server') }
end

execute 'set_pentaho_installed_license_path' do
  command 'export PENTAHO_INSTALLED_LICENSE_PATH=/opt/zeus/.pentaho/.installedLicenses.xml'
  #not_if { File.exists?('/opt/pentaho/server/data-integration-server') }
end

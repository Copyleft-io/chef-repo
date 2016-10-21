#
# Cookbook Name:: copyleft-pentaho-di
# Recipe:: pentaho_tomcat
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# MODIFY JDBC CONNECTION INFORMATION IN TOMCAT context.xml
# Database connection and network information, such as the username, password,
# driver class information, IP address or domain name, and port numbers for your
# DI Repository database are stored in the context.xml file.
#
# Modify this file to reflect the database connection and network information to
# reflect your operating environment. You also modify the values for the
# validationQuery parameters in this file if you have choosen to use an
# DI Repository database other than PostgreSQL.
#
# Consult your database documentation to determine the JDBC class name and
# connection string for your DI Repository database.
#
# Go to the /tomcat/webapps/pentaho-di/META-INF directory
# and open the context.xml file with any file editor. Comment out the resource
# references that refer to databases other than PostgreSQL
# such as MySQL, MS SQL Server, and Oracle.
#
# Then, add the following code to the file if it does not already exist.
# Be sure to adjust the port numbers and passwords to reflect your environment,
# if necessary.
#
# Make sure that the validationQuery variable for your database is set to this:
# validationQuery="select 1"
#
# Save the context.xml file, then close it.
#
# To make sure that the changes that you made in the context.xml file take effect
# when Tomcat is started, navigate to the tomcat/conf/Catalina directory.
#
# If the pentaho-di.xml file is in the present, delete it. It will be generated
# again when you start the DI Server, but will contain the changes that you just
# made in the context.xml file.


# CONFIGURE HTTP AND HTTPS PORTS ON TOMCAT
# Since the DI Server is configured to run on 9080 (http) and 9443 (https),
# you need to configure Tomcat for these ports as well.
# Use a text editor to open the server.xml file, which is located in
# pentaho/server/data-integration-server/<your tomcat installation directory/conf directory.
#
# Modify the connector port settings for http and https to reflect the
# DI Server ports (9080 and 9443).
#
# Save the changes and close the file.
tomcat_bin_dir = "#{node['tomcat']['directory']}/apache-tomcat-#{node['tomcat']['version']}/bin"

template "#{node['pentaho']['tomcat_directory']}/conf/server.xml" do
  source 'tomcat-server.xml.erb'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0644'
  action :create
  #notifies :run, 'execute[service_tomcat_restart]', :delayed
end

template '/etc/environment' do
  source 'etc_environment.erb'
end


# CONFIG PENTAHO-PDI TO RUN IN TOMCAT DIRECTORY
template "#{node['pentaho']['tomcat_directory']}/webapps/pentaho-di/META-INF/context.xml" do
  source 'tomcat-context.xml.erb'
  owner node['tomcat']['user']
  group node['tomcat']['user']
  only_if { ::File.exist?("#{node['pentaho']['tomcat_directory']}/webapps/pentaho-di/META-INF") }
  #notifies :run, 'execute[stop]', :delayed
  #subscribes :create, 'execute[start]', :delayed
end

template "#{node['pentaho']['tomcat_directory']}/webapps/pentaho-di/WEB-INF/web.xml" do
  source 'web.xml.erb'
  owner node['tomcat']['user']
  group node['tomcat']['user']
  only_if { ::File.exist?("#{node['pentaho']['tomcat_directory']}/webapps/pentaho-di/WEB-INF") }
end

template "#{node['pentaho']['tomcat_directory']}/webapps/pentaho-di/WEB-INF/classes/kettle-lifecycle-listeners.xml" do
  source 'kettle-lifecycle-listeners.xml.erb'
  owner node['tomcat']['user']
  group node['tomcat']['user']
  action :create
end

template "#{node['pentaho']['tomcat_directory']}/webapps/pentaho-di/WEB-INF/classes/kettle-registry-extensions.xml" do
  source 'kettle-registry-extensions.xml.erb'
  owner node['tomcat']['user']
  group node['tomcat']['user']
  action :create
end


link "#{node['pentaho']['directory']}/server/data-integration-server/tomcat" do
  to node['pentaho']['tomcat_directory']
end


## TOMCAT LINUX STARTUP SCRIPT
execute 'stop' do
  user node['tomcat']['user']
  command ".#{tomcat_bin_dir}/shutdown.sh"
  action :nothing
  notifies :run, 'execute[start]', :delayed
end

execute 'kill' do
  user node['tomcat']['user']
  command ".#{tomcat_bin_dir}/killtomcat.sh"
  action :nothing
  subscribes :run, 'execute[stop]', :immediately
end

execute 'start' do
  user node['tomcat']['user']
  command ".#{tomcat_bin_dir}/startup.sh"
  not_if "ps -ef | grep java | grep #{node['tomcat']['user']} | grep -v grep"
end

#
# Cookbook Name:: copyleft-pentaho-di
# Recipe:: pentaho_jar_files
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# After our repository has been configured, we must configure the web application
# servers to connect to the DI Repository. In this step, JDBC and JNDI connections
# are made to the Hibernate, Jackrabbit, and Quartz databases.
#
# By default, the DI Server software is configured to be deployed and run on the
# Tomcat server. As such, connections have already been specified and only the
# Tomcat context.xml file must be modified.
#
# If you plan to run the DI Server on Tomcat, you must modify JDBC Connection information.

# DOWNLOAD AND INSTALL JDBC DRIVERS AND JAR FILE DEPENDENCIES
# To connect to a database, including the BA Repository or DI Repository database,
# we will need to download and install a JDBC driver to the appropriate places
# for Pentaho components as well as on the the web application server that
# contains the Pentaho Server(s).

cookbook_file "#{node['pentaho']['directory']}/server/jdbc-distribution/postgresql-9.3-1104.jdbc4.jar" do
  source 'postgresql-9.3-1104.jdbc4.jar'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0777'
  action :create
end

#
# Cookbook Name:: copyleft-pentaho-di
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Pentaho Installation
# https://help.pentaho.com/Documentation/6.0/0F0/0L0/030/020
# http://wiki.pentaho.com/display/EAI/01.+Installing+Kettle
#
# Pentaho Data Integration comes in two varieties:
#  - Community Edition (CE)
#  - Enterprise Edition (EE)
#
# REQUIREMENTS
# - PDI requires the Oracle Java Runtime Environment (JRE) version 7
# - PDI does not require installation. Simply unpack the zip file into a folder of your choice.
#   We will be installing to /opt/pentaho/server

# INCLUDE COOKBOOK DEPENDENCIES
include_recipe 'copyleft-base'
include_recipe 'copyleft-java'
include_recipe 'copyleft-tomcat'
tomcat_bin_dir = "#{node['tomcat']['directory']}/apache-tomcat-#{node['tomcat']['version']}/bin"

# # CREATE PENTAHO USER
# user 'pentaho' do
#   comment 'Pentaho User'
#   home '/opt/pentaho'
#   shell '/bin/bash'
#   password 'Pa55w0rd'
# end

# # CREATED BY COPYLEFT-BASE BY DEFAULT
# # CREATE PENTAHO DIRECTORY STRUCTURE
# directory node['pentaho']['directory'] do
#   owner node['pentaho']['user']
#   group node['pentaho']['group']
#   mode '0755'
#   action :create
# end
#
# directory node['pentaho']['deploy_directory'] do
#   owner node['pentaho']['user']
#   group node['pentaho']['group']
#   mode '0755'
#   action :create
# end
#
# directory "#{node['pentaho']['directory']}/logs" do
#   owner node['pentaho']['user']
#   group node['pentaho']['group']
#   mode 00755
#   recursive true
#   action :create
# end

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

remote_file "#{node['pentaho']['tomcat_directory']}/webapps/pentaho-style.war" do
  source "file:///#{node['pentaho']['deploy_directory']}/pentaho-style.war"
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
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


# INITIALIZE POSTGRES DI REPOSITORY DATABASE
# To initialize PostgreSQL so that it serves as the DI Repository,
# you will need to run a few SQL scripts to create the Hibernate, Quartz,
# Jackrabbit (JCR), and Pentaho Operations Mart databases.

execute 'initialize_postgres_repository' do
  user 'postgres'
  command <<-EOH
    psql -ef #{node['pentaho']['directory']}/server/data-integration-server/data/postgresql/create_quartz_postgresql.sql
    psql -ef #{node['pentaho']['directory']}/server/data-integration-server/data/postgresql/create_repository_postgresql.sql
    psql -ef #{node['pentaho']['directory']}/server/data-integration-server/data/postgresql/create_jcr_postgresql.sql
    psql -ef #{node['pentaho']['directory']}/server/data-integration-server/data/postgresql/pentaho_mart_postgresql.sql
  EOH
  not_if { File.exists?("#{node['pentaho']['deploy_directory']}/server/data-integration-server/data/psql-repository-initialized.txt") }
end

cookbook_file "#{node['pentaho']['directory']}/server/data-integration-server/data/postgresql-repository-initialized.txt" do
  source 'postgresql-repository-initialized.txt'
  owner node['pentaho']['user']
  group node['pentaho']['group']
  mode '0755'
  action :create
end

# CONFIGURE POSTGRES DI REPOSITORY DATABASE
# Now that we have initialized your repository database, we will need to
# configure Quartz, Hibernate, Jackrabbit, and Pentaho Operations Mart for a
# PostgreSQL database.
#
# PostgreSQL is configured by default; if you kept the default passwords and port,
# you won't need to set up Quartz, Hibernate, Jackrabbit or the Pentaho Operations Mart.
#
# If you have a different port or different password, make sure that you change the
# password and port number in these examples to match the ones in your configuration.
# By default, the examples in this section are for a PostgreSQL database that
# runs on port 5432. The default password is also in these examples.
#
# If you have a different port or different password, complete all of the
# instructions in these steps.


# QUARTZ.PROPERTIES
# NOTE: PostgreSQL is configured by default
#
# Locate the _replace_jobstore_properties section and set the org.quartz.jobStore.driverDelegateClass as shown here.
# org.quartz.jobStore.driverDelegateClass = org.quartz.impl.jdbcjobstore.PostgreSQLDelegate
#
# Locate the # Configure Datasources section and set the org.quartz.dataSource.myDS.jndiURL equal to Quartz, like this.
# org.quartz.dataSource.myDS.jndiURL = Quartz


# HIBERNATE-SETTINGS.XML
# NOTE: PostgreSQL is configured by default
#
# Find the <config-file> tags and confirm that it is configured for PostgreSQL.
# <config-file>system/hibernate/postgresql.hibernate.cfg.xml</config-file>


# POSTGRESQL.HIBERNATE.CFG.XML
#
# NOTE: PostgreSQL is configured by default
# Make sure that the password and port number match the ones you specified in your configuration


# REPOSITORY.XML
# NOTE: PostgreSQL is configured by default
# Locate and verify or change the code so that the PostgreSQL lines are not
# commented out, but the MySQL, MS SQL Server, and Oracle lines are commented out.
#
# REPOSITORY
# <FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem">
#   <param name="driver" value="org.postgresql.Driver"/>
#   <param name="url" value="jdbc:postgresql://localhost:5432/di_jackrabbit"/>
#   ...
# </FileSystem>
#
# DATASTORE
# <DataStore class="org.apache.jackrabbit.core.data.db.DbDataStore">
#     <param name="url" value="jdbc:postgresql://localhost:5432/di_jackrabbit"/>
#     ...
#   </DataStore>
#
# WORKSPACES
# <FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem">
#       <param name="driver" value="org.postgresql.Driver"/>
#       <param name="url" value="jdbc:postgresql://localhost:5432/di_jackrabbit"/>
#      ...
#     </FileSystem>
#
# PERSISTENCE MANAGER
# <PersistenceManager class="org.apache.jackrabbit.core.persistence.bundle.PostgreSQLPersistenceManager">
#       <param name="url" value="jdbc:postgresql://localhost:5432/di_jackrabbit"/>
#       ...
#     </PersistenceManager>
#
# VERSIONING
# <FileSystem class="org.apache.jackrabbit.core.fs.db.DbFileSystem">
#       <param name="driver" value="org.postgresql.Driver"/>
#       <param name="url" value="jdbc:postgresql://localhost:5432/di_jackrabbit"/>
#      ...
#     </FileSystem>
#
# PERSISTENCE MANAGER (2nd Part)
# <PersistenceManager class="org.apache.jackrabbit.core.persistence.bundle.PostgreSQLPersistenceManager">
#       <param name="url" value="jdbc:postgresql://localhost:5432/di_jackrabbit"/>
#       ...
#     </PersistenceManager>
#
# DATABASE JOURNAL
# <Journal class="org.apache.jackrabbit.core.journal.DatabaseJournal">
#     <param name="revision" value="${rep.home}/revision" />
#     <param name="url" value="jdbc:postgresql://localhost:5432/di_jackrabbit"/>
#     <param name="driver" value="org.postgresql.Driver"/>
#     <param name="user" value="jcr_user"/>
#     <param name="password" value="password"/>
#     <param name="schema" value="postgresql"/>
#     <param name="schemaObjectPrefix" value="cl_j_"/>
# </Journal>


# PERFORM TOMCAT CONFIGURATIONS
# After our repository has been configured, we must configure the web application
# servers to connect to the DI Repository. In this step, JDBC and JNDI connections
# are made to the Hibernate, Jackrabbit, and Quartz databases.
#
# By default, the DI Server software is configured to be deployed and run on the
# Tomcat server. As such, connections have already been specified and only the
# Tomcat context.xml file must be modified.
#
# If you plan to run the DI Server on Tomcat, you must modify JDBC Connection information.


# DOWNLOAD AND INSTALL JDBC DRIVERS
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

# directory "#{node['pentaho']['directory']}/server/java/bin/java" do
#   owner 'pentaho'
#   group 'pentaho'
#   mode '0777'
#   recursive true
#   action :create
# end
#
# execute 'chown_pentaho_java' do
#   user 'root'
#   command 'chown -R pentaho:pentaho /opt/pentaho/server/java'
#   action :nothing
# end

# execute 'distribute_jdbc_files' do
#   user 'pentaho'
#   cwd '/opt/pentaho/server/jdbc-distribution'
#   command <<-EOH
#     ./distribute-files.sh
#   EOH
#   #not_if { File.exists?('/opt/pentaho/server/data-integration-server/data/psql-repository-initialized.txt') }
# end


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

# INSTALL LICENSE KEYS (TODO)
# Download the .lic file you want to install.
# Copy your .lic files to the DI Server.
# Navigate to the license-installer directory:  pentaho/license-installer
# Run install_license.sh with the install switch and the location and name of
# your .lic file as a parameter. You can specify multiple .lic files separated
# by spaces. Be sure to use backslashes to escape any spaces in the path or
# file name, like this:
#
execute 'install_pdi_ee_license' do
  user node['pentaho']['user']
  command "yes | .#{node['pentaho']['directory']}/license-installer/install_license.sh install /opt/zeus/deploy/Pentaho_PDI_EE.lic"
  action :nothing
end


# # MODIFY TOMCAT LINUX STARTUP SCRIPT
# execute 'stop' do
#   user node['tomcat']['user']
#   command ".#{tomcat_bin_dir}/shutdown.sh"
#   action :nothing
#   notifies :run, 'execute[start]', :delayed
# end
#
# execute 'kill' do
#   user node['tomcat']['user']
#   command ".#{tomcat_bin_dir}/killtomcat.sh"
#   action :nothing
#   subscribes :run, 'execute[stop]', :immediately
# end
#
# execute 'start' do
#   user node['tomcat']['user']
#   command ".#{tomcat_bin_dir}/startup.sh"
#   not_if "ps -ef | grep java | grep #{node['tomcat']['user']} | grep -v grep"
# end

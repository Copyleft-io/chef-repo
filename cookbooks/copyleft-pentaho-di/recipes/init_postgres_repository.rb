#
# Cookbook Name:: copyleft-pentaho-di
# Recipe:: init_postgres_repository
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

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

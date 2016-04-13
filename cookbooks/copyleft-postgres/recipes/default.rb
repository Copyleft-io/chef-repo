#
# Cookbook Name:: copyleft-postgres
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'postgresql'
package 'postgresql-contrib'

cookbook_file '/etc/postgresql/9.3/main/pg_hba.conf' do
  source 'pg_hba.conf'
  owner 'postgres'
  group 'postgres'
  mode '0644'
  action :create
end

cookbook_file '/etc/postgresql/9.3/main/postgresql.conf' do
  source 'postgresql.conf'
  owner 'postgres'
  group 'postgres'
  mode '0644'
  action :create
  notifies :run, 'execute[service_postgresql_restart]', :immediately
end

execute 'service_postgresql_restart' do
  user 'root'
  command 'service postgresql restart'
  action :nothing
end

#
# Cookbook Name:: copyleft-graphite
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.


# INSTALL PYTHON PACKAGE DEPENDENCIES
package 'python-dev'
package 'python-pip'
package 'python-django'
package 'libcairo2-dev'
package 'libpq-dev'
package 'python-psycopg2'

# APACHE MODE_WSGI
package 'apache2'
package 'libapache2-mod-wsgi'

# SETTING ENVIRONMENT VARIABLES
# ENV['GRAPHITE_ROOT'] = '/opt/zeus/graphite'

# GRAPHITE DIRECTORY
directory '/opt/zeus/graphite' do
  owner 'zeus'
  group 'zeus'
  mode '0755'
  action :create
  recursive true
end

# INSTALLATION
execute 'install_django_tagging' do
  user 'root'
  command <<-EOH
    pip install django-tagging==0.3.6
  EOH
  #not_if { File.exists?("#{node['pentaho']['deploy_directory']}/server/data-integration-server/data/psql-repository-initialized.txt") }
end

execute 'install_ceres' do
  user 'root'
  command <<-EOH
    pip install https://github.com/graphite-project/ceres/tarball/master
  EOH
  #not_if { File.exists?("#{node['pentaho']['deploy_directory']}/server/data-integration-server/data/psql-repository-initialized.txt") }
end

execute 'install_whisper' do
  user 'root'
  command <<-EOH
    pip install whisper
  EOH
  #not_if { File.exists?("#{node['pentaho']['deploy_directory']}/server/data-integration-server/data/psql-repository-initialized.txt") }
end

execute 'install_carbon' do
  user 'root'
  command <<-EOH
    pip install carbon --install-option="--prefix=/opt/zeus/graphite" --install-option="--install-lib=/opt/zeus/graphite/lib"
  EOH
  not_if { File.exists?("/opt/zeus/graphite/lib/carbon") }
end

execute 'install_graphite' do
  user 'root'
  command <<-EOH
    pip install graphite-web --install-option="--prefix=/opt/zeus/graphite" --install-option="--install-lib=/opt/zeus/graphite/webapp"
  EOH
  not_if { File.exists?("/opt/zeus/graphite/webapp/graphite") }
end

template '/tmp/create-graphite-postgresql.sql' do
  source 'create-graphite-postgresql.sql.erb'
  mode '0755'
  owner 'postgres'
  group 'postgres'
  action :create
end

execute 'configure_postgres' do
  user 'postgres'
  command <<-EOH
    psql -ef /tmp/create-graphite-postgresql.sql
  EOH
  not_if { File.exists?("/opt/zeus/graphite/webapp/graphite/local_settings.py") }
end

template '/opt/zeus/graphite/conf/dashboard.conf' do
  source 'dashboard.conf.erb'
  mode '0755'
  owner 'zeus'
  group 'zeus'
  action :create
end

template '/opt/zeus/graphite/conf/graphTemplates.conf' do
  source 'graphTemplates.conf.erb'
  mode '0755'
  owner 'zeus'
  group 'zeus'
  action :create
end

template '/opt/zeus/graphite/webapp/graphite/local_settings.py' do
  source 'local_settings.py.erb'
  mode '0755'
  owner 'zeus'
  group 'zeus'
  action :create
end

template '/opt/zeus/graphite/webapp/graphite/graphite-sync-postgres.sh' do
  source 'graphite-sync-postgres.sh.erb'
  mode '0755'
  owner 'zeus'
  group 'zeus'
  action :create
  notifies :run, 'execute[sync_postgres]', :immediately
end

execute 'sync_postgres' do
  user 'root'
  cwd '/opt/zeus/graphite/webapp/graphite'
  command <<-EOH
    ./graphite-sync-postgres.sh
  EOH
  action :nothing
end

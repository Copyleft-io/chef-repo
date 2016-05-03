#
# Cookbook Name:: copyleft-elkstack
# Recipe:: nginx
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

%w(epel-release nginx httpd-tools).each do |tool_set|
  package tool_set do
    action :install
  end
end

execute 'htpasswd -bc /etc/nginx/htpasswd.users kibanaadmin kibanaadmin' do
  creates '/etc/nginx/htpasswd.users'
end

template '/etc/nginx/nginx.conf' do
  source 'nginx.conf.erb'
  notifies :restart, 'service[nginx]', :delayed
end

template 'kibana.conf' do
  source 'nginx_kibana.conf.erb'
  path '/etc/nginx/conf.d/kibana.conf'
  notifies :restart, 'service[nginx]', :delayed
end

service 'nginx' do
  action [:enable, :start]
end

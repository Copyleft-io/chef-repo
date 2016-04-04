#
# Cookbook Name:: copyleft-elkstack
# Recipe:: kibana
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'kibana'

template 'kibana.yml' do
  path '/opt/kibana/config/kibana.yml'
  source 'kibana.yml.erb'
end

service 'kibana' do
  action [:enable, :start]
end

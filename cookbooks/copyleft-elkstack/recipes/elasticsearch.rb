#
# Cookbook Name:: copyleft-elkstack
# Recipe:: elasticsearch
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Install Oracle java 1.8
cookbook_file 'jdk-8u73-linux-x64.rpm'

package 'jdk' do
  source 'jdk-8u73-linux-x64.rpm'
end

package 'elasticsearch'

template 'elasticsearch.yml' do
  path '/etc/elasticsearch/elasticsearch.yml'
  content 'elasticsearch.yml.rb'
  owner 'elasticsearch'
  group 'elasticsearch'
end

service 'elasticsearch' do
  action [:enable, :start]
end

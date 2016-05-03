#
# Cookbook Name:: copyleft-elkstack
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

include_recipe 'yum'

yum_repository 'elasticseach' do
  description 'Elasticsearch repository for 2.x packages'
  baseurl 'http://packages.elastic.co/elasticsearch/2.x/centos'
  gpgcheck false
  gpgkey 'http://packages.elastic.co/GPG-KEY-elasticsearch'
  enabled true
end

yum_repository 'logstash' do
  description 'Logstash repository for 2.2 packages'
  baseurl 'http://packages.elastic.co/logstash/2.2/centos'
  gpgkey 'http://packages.elastic.co/GPG-KEY-elasticsearch'
  gpgcheck false
  enabled true
end

yum_repository 'kibana' do
  description 'Kibana repository for 4.4 packages'
  baseurl 'http://packages.elastic.co/kibana/4.4/centos'
  gpgkey 'http://packages.elastic.co/GPG-KEY-elasticsearch'
  gpgcheck false
  enabled true
end

include_recipe 'copyleft-elkstack::elasticsearch'
include_recipe 'copyleft-elkstack::logstash'
include_recipe 'copyleft-elkstack::kibana'
include_recipe 'copyleft-elkstack::nginx'

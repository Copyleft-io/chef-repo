#
# Cookbook Name:: copyleft-elkstack
# Recipe:: logstash
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'logstash'

template '02-input-beats.conf' do
  path '/etc/logstash/conf.d/02-input-beats.conf'
  source 'logstash/02-input-beats.conf.erb'
  notifies ':restart', 'service[logstash]', :delayed
end

template '50-filter-syslog.conf' do
  path '/etc/logstash/conf.d/50-filter-syslog.conf'
  source 'logstash/50-filter-syslog.conf.erb'
  notifies ':restart', 'service[logstash]', :delayed
end

template '90-output-elastic.conf' do
  path '/etc/logstash/conf.d/90-output-elastic.conf'
  source 'logstash/90-output-elastic.conf.erb'
  notifies ':restart', 'service[logstash]', :delayed
end

service 'logstash' do
  action [:enable, :start]
end

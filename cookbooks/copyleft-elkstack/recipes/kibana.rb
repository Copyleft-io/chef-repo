#
# Cookbook Name:: copyleft-elkstack
# Recipe:: kibana
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

package 'kibana'
package 'unzip'

template 'kibana.yml' do
  path '/opt/kibana/config/kibana.yml'
  source 'kibana.yml.erb'
end

service 'kibana' do
  action [:enable, :start]
end

remote_file 'beats-dashboards-1.1.0.zip' do
  path File.join(Chef::Config['file_cache_path'], 'beats-dashboards-1.1.0.zip')
  source 'https://download.elastic.co/beats/dashboards/beats-dashboards-1.1.0.zip'
  notifies :run, 'execute[install_dashboard]', :immediate
end
remote_file 'filebeat-index-template.json' do
  path File.join(Chef::Config['file_cache_path'], 'filebeat-index-template.json')
  source 'https://gist.githubusercontent.com/thisismitch/3429023e8438cc25b86c/raw/d8c479e2a1adcea8b1fe86570e42abab0f10f364/filebeat-index-template.json'
  notifies :run, 'execute[install_beats]', :immediate
end

execute 'install_dashboard' do
  action :nothing
  command "
    cd #{Chef::Config['file_cache_path']}
    unzip beats-dashboards-1.1.0.zip
    cd beats*
    ./load.sh
  "
end

execute 'install_beats' do
  action :nothing
  command "curl -XPUT 'http://localhost:9200/_template/filebeat?pretty' -d@#{Chef::Config['file_cache_path']}/filebeat-index-template.json"
end

#
# Cookbook Name:: copyleft-nodejs
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# DOWNLOAD DEPENDENCIES
remote_file node['nodejs']['remote_file'] do
  source node['nodejs']['source']
end

# INSTALL NODE
script 'install_node' do
  interpreter "bash"
  code <<-EOH
    tar -C /usr/local --strip-components 1 -xzf #{node.nodejs.remote_file}
    EOH
  not_if { File.exists?('/usr/local/bin/node') }
end

# INSTALL PM2
script 'install_pm2' do
  interpreter "bash"
  code <<-EOH
    npm install pm2 -g
    EOH
  not_if { File.exists?('/usr/local/bin/pm2') }
end

# CREATE VERSION FILE


# CONSUL SERVER
# execute 'consul_server' do
#   user 'root'
#   command "consul agent -server -bootstrap-expect=1 \
#     -data-dir=/tmp/consul -node=#{node['hostname']} -bind=#{node['ipaddress']} \
#     -config-dir=/etc/consul.d"
#   action :nothing
# end

template '/etc/init.d/consul' do
  source 'consul.init.erb'
  mode 00755
  variables(
    user: 'root',
    startup_type: '-server -ui -bootstrap-expect=1',
    dir: node['consul']['dir'],
    options: {
      'node' => node['fqdn'],
      'data-dir' => "#{node['consul']['dir']}/data",
      'config-dir' => "#{node['consul']['dir']}/configs",
      'dc' => node.chef_environment,
      'advertise' => node['ipaddress']
    }
  )
  notifies :restart, 'service[consul]', :delayed
  notifies :run, 'execute[create_version_file]', :immediately
end

execute 'create_version_file' do
  user 'root'
  command "echo #{node['consul']['version']} > /var/chef/versions/consul-server.version"
  action :nothing
end

service 'consul' do
  action :start
  not_if 'service consul status'
end

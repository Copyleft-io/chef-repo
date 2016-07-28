
directory '/tmp/uchiwa' do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

remote_file '/var/cache/apt/archives/uchiwa_0.17.0-1_amd64.deb' do
  source 'http://dl.bintray.com/palourde/uchiwa/uchiwa_0.17.0-1_amd64.deb'
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

execute 'install_uchiwa' do
  user 'root'
  command <<-EOH
    dpkg -i /var/cache/apt/archives/uchiwa_0.17.0-1_amd64.deb
  EOH
  not_if { File.exists?("/etc/init.d/uchiwa") }
end

service 'uchiwa' do
  action [:enable, :start]
end

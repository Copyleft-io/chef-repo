#
# Cookbook Name:: copyleft-base
# Recipe:: security
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# CONFIGURE SUDOERS
template '/etc/sudoers' do
  source 'sudoers.erb'
  action :create
end

# CONFIGURE SSHD
# - disable root login
template '/etc/ssh/sshd_config' do
  source 'sshd_config.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  notifies :restart, 'service[ssh]', :delayed
end


# INSTALL Security Packages
node['base']['security']['install_packages'].each do |name|
  package name do
    action :install
  end
end

# CONFIGURE RKHUNTER aka Root Kit Hunter
template '/etc/rkhunter.conf' do
  source 'rkhunter.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  #notifies :run, 'execute[rkhunter_restart]', :delayed
end

template '/etc/default/rkhunter' do
  source 'rkhunter-default.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  #notifies :run, 'execute[rkhunter_restart]', :delayed
end

# # The command 'rkhunter -C' is run after any config changes have been made.
# # ONLY RUN IF rkhunter.conf TEMPLATE IS UPDATED
# execute "rkhunter_restart" do
#   command "rkhunter -C"
#   action :nothing
# end


template '/etc/audit/rules.d/audit.rules' do
  source 'audit.rules.erb'
  owner 'root'
  group 'root'
  mode '0640'
  action :create
end

# CONFIGURE SSH SERVICE TO START ON BOOT
service "ssh" do
  action [:enable, :start]
end

# CONFIGURE ACCT SERVICE TO START ON BOOT
service "acct" do
  action [:enable, :start]
end

# CONFIGURE AUDIT SERVICE TO START ON BOOT
service "auditd" do
  action [:enable, :start]
end

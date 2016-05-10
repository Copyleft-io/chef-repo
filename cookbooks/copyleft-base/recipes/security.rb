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
  notifies :run, 'execute[service_ssh_restart]', :immediately
end

# RESTART SSH DAEMON FOR CONFIG CHANGES TO TAKE EFFECT
# ONLY RUN IF sshd_config TEMPLATE IS UPDATED
execute "service_ssh_restart" do
  command "service ssh restart"
  action :nothing
end

# INSTALL Security Packages
node['base']['security']['install_packages'].each do |name|
  package name do
    action :install
  end
end

# CONFIGURE RKHUNTER aka Root Kit Hunter
template '/etc/rkunter.conf' do
  source 'rkhunter.conf.erb'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
  #notifies :run, 'execute[rkhunter_restart]', :delayed
end

template '/etc/default/rkunter' do
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


# CONFIGURE ACCT SERVICE TO START ON BOOT
service "acct" do
  action [:enable, :start]
end

# CONFIGURE AUDIT SERVICE TO START ON BOOT
service "auditd" do
  action [:enable, :start]
end

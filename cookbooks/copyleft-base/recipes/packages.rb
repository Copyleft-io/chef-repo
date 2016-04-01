#
# Cookbook Name:: copyleft-base
# Recipe:: packages
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# UPDATE apt-get
execute "apt-get update" do
  command "apt-get update"
end

# INSTALL Base Packages
node['base']['apt']['install_packages'].each do |name|
  package name do
    action :install
  end
end

# PURGE Unnecessary Packages
node['base']['apt']['purge_packages'].each do |name|
  package name do
    action :purge
  end
end

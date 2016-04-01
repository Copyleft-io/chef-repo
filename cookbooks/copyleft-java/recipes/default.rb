#
# Cookbook Name:: copyleft-java
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Note: Run apt-get update prior to installing Java packages.
# This is done in copyleft-base::default


# INSTALL Default JRE/JDK
#package 'default-jre'
#package 'default-jdk'


# INSTALL OpenJDK7
#package openjdk-7-jre
#package openjdk-7-jdk


# INSTALL Oracle JDK 7
script 'install_oracle_jdk' do
  user 'root'
  interpreter "bash"
    code <<-EOH
      apt-get install software-properties-common --yes
      apt-get install python-software-properties --yes
      add-apt-repository "ppa:webupd8team/java"
      apt-get update
      echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
      echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
      apt-get install oracle-java7-installer --yes
    EOH
  not_if { File.exists?('/usr/bin/java') }
end

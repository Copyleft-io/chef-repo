#
# Cookbook Name:: copyleft-base
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.
include_recipe "chef-client::config"
include_recipe "copyleft-base::base"
include_recipe "copyleft-base::security"
include_recipe "copyleft-base::packages"

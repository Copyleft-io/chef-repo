#
# Cookbook Name:: copyleft-pentaho-di
# Recipe:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# Pentaho Installation
# https://help.pentaho.com/Documentation/6.0/0F0/0L0/030/020
# http://wiki.pentaho.com/display/EAI/01.+Installing+Kettle
#
# Pentaho Data Integration comes in two varieties:
#  - Community Edition (CE)
#  - Enterprise Edition (EE)
#
# REQUIREMENTS
# - PDI requires the Oracle Java Runtime Environment (JRE) version 7
# - PDI does not require installation. Simply unpack the zip file into a folder of your choice.
#   We will be installing to /opt/pentaho/server

# INCLUDE COOKBOOK DEPENDENCIES
include_recipe 'copyleft-base'
include_recipe 'copyleft-java'
include_recipe 'copyleft-tomcat'
tomcat_bin_dir = "#{node['tomcat']['directory']}/apache-tomcat-#{node['tomcat']['version']}/bin"

# INCLUDE COOKBOOK RECIPES

## CREATE PENTAHO DIRECTORY STRUCTURE
include_recipe 'copyleft-pentaho-di::pentaho_directory'

## STAGE PENTAHO DEPLOYMENT ARTIFACTS
include_recipe 'copyleft-pentaho-di::pentaho_artifacts'

## INSTALL PENTAHO
include_recipe 'copyleft-pentaho-di::pentaho_install'

## INITIALIZE POSTGRES DI REPOSITORY DATABASE
include_recipe 'copyleft-pentaho-di::pentaho_repository'

## DOWNLOAD AND INSTALL JAR FILE DEPENDENCIES INCLUDING JDBC DRIVERS
include_recipe 'copyleft-pentaho-di::pentaho_jar_files'

## PERFORM TOMCAT CONFIGURATIONS
include_recipe 'copyleft-pentaho-di::pentaho_tomcat'

## INSTALL PENTAHO LICENSES
include_recipe 'copyleft-pentaho-di::pentaho_licenses'

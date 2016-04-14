#
# Cookbook Name:: copyleft-pentaho-di
# Recipe:: pentaho_licenses
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

# INSTALL LICENSE KEYS (TODO)
# Download the .lic file you want to install.
# Copy your .lic files to the DI Server.
# Navigate to the license-installer directory:  pentaho/license-installer
# Run install_license.sh with the install switch and the location and name of
# your .lic file as a parameter. You can specify multiple .lic files separated
# by spaces. Be sure to use backslashes to escape any spaces in the path or
# file name, like this:
#
execute 'install_pdi_ee_license' do
  user node['pentaho']['user']
  command "yes | .#{node['pentaho']['directory']}/license-installer/install_license.sh install /opt/zeus/deploy/Pentaho_PDI_EE.lic"
  action :nothing
end

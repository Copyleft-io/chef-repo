#
# Cookbook Name:: copyleft-jumpcloud
# Recipe:: default
#
# Copyright 2016, Copyleft.io
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

# NOTE: default['jumpcloud']['x_connect_key'] and default['jumpcloud']['kickstart_url']
# are stored in attributes/default.rb which has been included in the gitignore
# Examples:
# default['jumpcloud']['x_connect_key'] = "'x-connect-key: <your_jumphost_connect_key_goes_here>'"
# default['jumpcloud']['kickstart_url'] = "'https://kickstart.jumpcloud.com/Kickstart'"


# INSTALL JUMPCLOUD AGENT
package 'curl'
package 'sudo'
package 'bash'
execute 'agent_install' do
  command "curl --silent --show-error --header #{node['jumpcloud']['x_connect_key']} #{node['jumpcloud']['kickstart_url']} | bash"
  path [ '/sbin', '/bin', '/usr/sbin', '/usr/bin' ]
  timeout 600
  creates '/opt/jc'
end

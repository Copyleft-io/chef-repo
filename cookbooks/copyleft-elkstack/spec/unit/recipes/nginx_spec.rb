#
# Cookbook Name:: copyleft-elkstack
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'copyleft-elkstack::nginx' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs packages for nginx' do
      expect(chef_run).to install_package('epel-release')
      expect(chef_run).to install_package('nginx')
      expect(chef_run).to install_package('httpd-tools')
    end

    it 'updates /etc/nginx/nginx.conf' do
      expect(chef_run).to create_template('/etc/nginx/nginx.conf')
    end
    it 'creates template /etc/nginx/conf.d/kibana.conf' do
      expect(chef_run).to create_template('kibana.conf').with(
        path: '/etc/nginx/conf.d/kibana.conf'
      )
    end
    it 'creates the htpasswd file' do
      expect(chef_run).to run_execute(
        'htpasswd -bc /etc/nginx/htpasswd.users kibanaadmin kibanaadmin'
      )
    end
    it 'starts nginx' do
      expect(chef_run).to enable_service('nginx')
      expect(chef_run).to start_service('nginx')
    end
  end
end

#
# Cookbook Name:: copyleft-elkstack
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'copyleft-elkstack::kibana' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    it 'installs packages for kibana' do
      expect(chef_run).to install_package('kibana')
      expect(chef_run).to install_package('unzip')
    end
    it 'creates logstash templates' do
      expect(chef_run).to create_template('kibana.yml')
    end
    it 'starts kibana' do
      expect(chef_run).to enable_service('kibana')
      expect(chef_run).to start_service('kibana')
    end
    it 'downloads kibana templates' do
      expect(chef_run).to create_remote_file('beats-dashboards-1.1.0.zip')
      expect(chef_run).to create_remote_file('filebeat-index-template.json')
    end

    it 'does not install kibana templates' do
      expect(chef_run).to_not run_execute('install_dashboard')
      expect(chef_run).to_not run_execute('install_beats')
    end
  end
end

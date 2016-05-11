#
# Cookbook Name:: copyleft-elkstack
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'copyleft-elkstack::logstash' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
    it 'installs packages for logstash' do
      expect(chef_run).to install_package('logstash')
    end
    it 'creates logstash templates' do
      expect(chef_run).to create_template('02-input-beats.conf')
      expect(chef_run).to create_template('50-filter-syslog.conf')
      expect(chef_run).to create_template('90-output-elastic.conf')
    end
    it 'starts logstash' do
      expect(chef_run).to enable_service('logstash')
      expect(chef_run).to start_service('logstash')
    end
  end
end

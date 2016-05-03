#
# Cookbook Name:: copyleft-elkstack
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'copyleft-elkstack::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates 3 yum repos for Elastic products'
    it 'install and configure the elasticsearch package' do
      expect(chef_run).to include_recipe 'copyleft-elkstack::elasticsearch'
    end
    it 'install and configure the logstash package' do
      expect(chef_run).to include_recipe 'copyleft-elkstack::logstash'
    end
    it 'install and configures the kibana package' do
      expect(chef_run).to include_recipe 'copyleft-elkstack::kibana'
    end
    it 'install and configure the nginx package' do
      expect(chef_run).to include_recipe 'copyleft-elkstack::nginx'
    end
  end
end

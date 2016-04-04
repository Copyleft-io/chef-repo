#
# Cookbook Name:: copyleft-elkstack
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'copyleft-elkstack::default' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::ServerRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'creates 3 yum repos for Elastic products'
    it 'installs the logstash package'
    it 'installs the kibana package'
    it 'Configures logstash diverts for filebeats data into the elasticsearch \
      service'
    it 'starts the logstash service'
    it 'configures kibana to read data from elasticsearch'
    it 'starts the kibana service'
  end
end

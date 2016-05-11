#
# Cookbook Name:: copyleft-elkstack
# Spec:: default
#
# Copyright (c) 2016 The Authors, All Rights Reserved.

require 'spec_helper'

describe 'copyleft-elkstack::elasticsearch' do
  context 'When all attributes are default, on an unspecified platform' do
    let(:chef_run) do
      runner = ChefSpec::SoloRunner.new
      runner.converge(described_recipe)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end

    it 'installs the elasticseach and JDK 8 packages' do
      expect(chef_run).to install_package('elasticsearch')
      expect(chef_run).to install_package('jdk')
    end

    it 'creates the elasticseach.yml file from template' do
      expect(chef_run).to create_template('/etc/elasticsearch/elasticsearch.yml').with(
        user: 'elasticsearch',
        group: 'elasticsearch'
      )
    end

    it 'creates the rpm for hte JDK 8 install' do
      expect(chef_run).to create_cookbook_file('jdk-8u73-linux-x64.rpm')
    end

    it 'enables and starts the elasticseach service' do
      expect(chef_run).to enable_service('elasticsearch')
      expect(chef_run).to start_service('elasticsearch')
    end
  end
end

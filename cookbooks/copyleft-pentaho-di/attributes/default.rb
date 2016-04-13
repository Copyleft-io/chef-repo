default['pentaho']['directory'] = '/opt/zeus/pentaho'
default['pentaho']['deploy_directory'] = '/opt/zeus/deploy'
default['pentaho']['tomcat_directory'] = '/opt/zeus/tomcat'
default['pentaho']['solutions_directory'] = '/opt/zeus/pentaho/server/data-integration-server/pentaho-solutions'
default['pentaho']['user'] = 'zeus'
default['pentaho']['group'] = 'zeus'

total_memory = (node['memory']['total']).to_i / 1024

puts "Total memory for this node: #{total_memory}"

default['pentaho']['di']['tuning']['xms'] = (total_memory * 0.25).to_i
default['pentaho']['di']['tuning']['xmx'] = (total_memory * 0.75).to_i

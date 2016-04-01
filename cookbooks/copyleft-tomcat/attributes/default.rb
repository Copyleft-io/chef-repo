default['tomcat']['directory'] = '/opt/zeus'
default['tomcat']['deploy_directory'] = '/opt/zeus/deploy'
default['tomcat']['user'] = 'zeus'
default['tomcat']['group'] = 'zeus'
default['tomcat']['version'] = '7.0.68'
default['tomcat']['app_version_file'] = File.join(node['tomcat']['directory'], 'tomcat.version')
default['tomcat']['catalina_pid_file'] = '/opt/zeus/logs/catalina.pid'


# DEPLOYMENT DIRECTORY
default['tomcat']['download_directory'] = "#{default['tomcat']['directory']}/deploy"

# FILES TO DOWNLOAD
default['tomcat']['zip'] =  "http://apache.cs.utah.edu/tomcat/tomcat-7/v7.0.68/bin/apache-tomcat-7.0.68.zip"

# PERFORMANCE TUNING SETTINGS
total_memory = (node['memory']['total']).to_i
default['tomcat']['tuning']['xms'] = (total_memory * 0.25).to_i
default['tomcat']['tuning']['xmx'] = (total_memory * 0.75).to_i
maxperm_size = (total_memory * 0.50).to_i
maxperm_size = node['tomcat']['tuning']['xmx'] if maxperm_size > node['tomcat']['tuning']['xmx']
default['tomcat']['tuning']['maxperm'] = maxperm_size
default['tomcat']['tuning']['log_level'] = 'INFO'

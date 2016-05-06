# copyleft-base for ubuntu 16.04

# CONFIGURE BASE USER
default['base']['user'] = 'zeus'
default['base']['password'] = 'olympus'
default['base']['group'] = 'zeus'

# CONFIGURE BASE DIRECTORY
default['base']['directory'] = '/opt/zeus'
default['base']['deploy_directory'] = '/opt/zeus/deploy'
default['base']['logs_directory'] = '/opt/zeus/logs'

# PACKAGES
default['base']['apt']['install_packages'] =  %w{ curl expect git gparted logwatch netcat vim unzip zip}
default['base']['apt']['purge_packages'] =  %w{  }

# SECURITY
default['base']['security']['permit_root_login'] = 'no'
default['base']['security']['install_packages'] =  %w{ acct auditd chkrootkit rkhunter }

# CONFIGURE RKHUNTER
default['base']['security']['rkhunter']['mail_on_warning'] = 'security@copyleft.io'
default['base']['security']['rkhunter']['cron_daily_run'] = true
default['base']['security']['rkhunter']['cron_db_update'] = true
default['base']['security']['rkhunter']['db_update_email'] = true
default['base']['security']['rkhunter']['report_email'] = 'security@copyleft.io'

# CONFIGURE CHKROOTKIT
default['base']['security']['chkrootkit']['run_daily'] = true
default['base']['security']['chkrootkit']['run_daily_opts'] = ''
default['base']['security']['chkrootkit']['diff_mode'] = false

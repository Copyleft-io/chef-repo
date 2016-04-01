# copyleft-base for ubuntu 14.04

default['base']['apt']['install_packages'] =  %w{ curl git gparted logwatch vim unzip zip}
default['base']['apt']['purge_packages'] =  %w{  }

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

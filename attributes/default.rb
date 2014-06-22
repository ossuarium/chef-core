#
# Cookbook Name:: otr
# Attributes:: default
#

# Run directory.
default['otr']['run_dir'] = '/var/run'

#
# Disable available servers by default.
# These will be enabled automatically by recipes that need them.
#

default['otr']['servers'] = {
  http: false,
  https: false,
  mysql: false,
}

#
# Configuration for phpMyAdmin.
#

default['otr']['phpmyadmin']['pma_database'] = 'phpmyadmin'
default['otr']['phpmyadmin']['pma_username'] = 'phpmyadmin'

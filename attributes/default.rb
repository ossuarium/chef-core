#
# Cookbook Name:: otr
# Attributes:: default
#

#
# Configuration for phpMyAdmin.
#

default['otr']['phpmyadmin']['pma_database'] = 'phpmyadmin'
default['otr']['phpmyadmin']['pma_username'] = 'phpmyadmin'

#
# All attributes below are configured automatically,
# and should not need to be changed.
#

# Run directory.
# Set based on platform and version.
default['otr']['run_dir'] = '/var/run'

# Disable available servers by default.
# These will be enabled automatically by recipes that need them.
default['otr']['servers'] = {
  http: false,
  https: false,
  mysql: false,
}

#
# Cookbook Name:: core
# Attributes:: default
#

default['core']['common_system'] = true
default['core']['contact'] = 'evan@ourtownrentals.com'

default['core']['packages'] = []

#
# Configuration for phpMyAdmin.
#

default['core']['phpmyadmin']['pma_database'] = 'phpmyadmin'
default['core']['phpmyadmin']['pma_username'] = 'phpmyadmin'

#
# Configuration for MySQL.
#

default['core']['mysql_sudoroot_user'] = 'sudoroot'

#
# Service configuration.
#

default['core']['service']['dirs'] = [
  'shared',
]

#
# Services and apps.
#

default['core']['services'] = []
default['core']['apps'] = []

#
# All attributes below are configured automatically,
# and should not need to be changed.
#

# Run directory.
default['core']['run_dir'] = '/var/run'

# Serve directory.
default['core']['srv_dir'] = '/srv'

# Home directory.
default['core']['home_dir'] = '/home'

# Disable available servers by default.
# These will be enabled automatically by recipes that need them.
default['core']['servers'] = {
  http: false,
  https: false,
  mysql: false,
}

# Interface facing the private network.
default['core']['private_interface'] = 'eth1'

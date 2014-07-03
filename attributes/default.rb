#
# Cookbook Name:: otr
# Attributes:: default
#

default['otr']['contact'] = 'evan@ourtownrentals.com'

default['otr']['packages'] = []

#
# Configuration for phpMyAdmin.
#

default['otr']['phpmyadmin']['pma_database'] = 'phpmyadmin'
default['otr']['phpmyadmin']['pma_username'] = 'phpmyadmin'

#
# Configuration for MySQL.
#

default['otr']['mysql_sudoroot_user'] = 'sudoroot'

#
# Service configuration.
#

default['otr']['service']['dirs'] = [
  'shared',
]

#
# Services and apps.
#

default['otr']['services'] = []
default['otr']['apps'] = []

#
# All attributes below are configured automatically,
# and should not need to be changed.
#

# Run directory.
default['otr']['run_dir'] = '/var/run'

# Serve directory.
default['otr']['srv_dir'] = '/srv'

# Home directory.
default['otr']['home_dir'] = '/home'

# Disable available servers by default.
# These will be enabled automatically by recipes that need them.
default['otr']['servers'] = {
  http: false,
  https: false,
  mysql: false,
}

# Interface facing the private network.
default['otr']['private_interface'] = 'eth1'

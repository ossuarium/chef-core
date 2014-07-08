#
# Cookbook Name:: core
# Attributes:: default
#

#
# Global configuration.
#

default['core']['common_system'] = true
default['core']['contact'] = 'evan@ourtownrentals.com'
default['core']['packages'] = []

#
# Configuration for storage.
#

default['core']['storage_group'] = 'www-data'

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
# LAMP configuration.
#

default['core']['lamp']['handler_extensions'] = %w(php)
default['core']['lamp']['pass_header'] = %w(Authorization)

#
# Services, storage, and apps.
#

default['core']['services'] = {}
default['core']['apps'] = {}
default['core']['storage'] = {}

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

# Storage directory.
default['core']['storage_dir'] = '/storage'

# Exports configuration file.
default['core']['exports_conf'] = '/etc/exports'

# Disable available servers by default.
# These will be enabled automatically by recipes that need them.
default['core']['servers'] = {
  http: false,
  https: false,
  mysql: false,
  nfs: false,
}

# Interface facing the private network.
default['core']['private_interface'] = 'eth1'

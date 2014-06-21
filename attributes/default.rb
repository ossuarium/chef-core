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

default['otr']['servers']['http'] = false
default['otr']['servers']['https'] = false
default['otr']['servers']['mysql'] = false

#
# Configuration for phpMyAdmin.
#

# Setup phpMyAdmin control database and user.
# The user's password will be generated securely,
# but can be set with `pma_password`.
default['otr']['phpmyadmin']['pma_database'] = 'phpmyadmin'
default['otr']['phpmyadmin']['pma_username'] = 'phpmyadmin'

#
# Cookbook Name:: otr
# Attributes:: database_admin
#

#
# Configuration for phpMyAdmin.
#

# Setup phpMyAdmin control database and user.
# The user's password will be generated securely,
# but can be set with `pma_password`.
default['otr']['phpmyadmin']['pma_database'] = 'phpmyadmin'
default['otr']['phpmyadmin']['pma_username'] = 'phpmyadmin'

#
# Cookbook Name:: otr
# Attributes:: system
#

#
# Set sudo attributes.
#

default['authorization']['sudo']['users'] = []
default['authorization']['sudo']['groups'] = ['sysadmin']
default['authorization']['sudo']['passwordless'] = true
default['authorization']['sudo']['include_sudoers_d'] = true

#
# Set sshd attributes.
#

default['openssh']['server']['password_authentication'] = 'no'
default['openssh']['server']['challenge_response_authentication'] = 'no'
default['openssh']['server']['permit_root_login'] = 'no'
default['openssh']['server']['t_c_p_keep_alive'] = 'yes'

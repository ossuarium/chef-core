#
# Cookbook Name:: otr
# Attributes:: system
#

#
# Configuration for sudo.
#

default['authorization']['sudo']['users'] = []
default['authorization']['sudo']['groups'] = ['sysadmin']
default['authorization']['sudo']['passwordless'] = true
default['authorization']['sudo']['include_sudoers_d'] = true

#
# Configuration for sshd.
#

default['openssh']['server']['password_authentication'] = 'no'
default['openssh']['server']['challenge_response_authentication'] = 'no'
default['openssh']['server']['permit_root_login'] = 'no'
default['openssh']['server']['t_c_p_keep_alive'] = 'yes'

#
# Cookbook Name:: core
# Recipe:: _common_system
#

node.default['annoyances']['debian']['perform_apt_get_update'] = false

#
# Configuration for sudo.
#

node.default['authorization']['sudo']['users'] = []
node.default['authorization']['sudo']['groups'] = ['sysadmin']
node.default['authorization']['sudo']['passwordless'] = true
node.default['authorization']['sudo']['include_sudoers_d'] = true

#
# Configuration for sshd.
#

node.default['openssh']['server']['password_authentication'] = 'no'
node.default['openssh']['server']['challenge_response_authentication'] = 'no'
node.default['openssh']['server']['permit_root_login'] = 'no'
node.default['openssh']['server']['t_c_p_keep_alive'] = 'yes'
node.default['openssh']['server']['allow_agent_forwarding'] = 'yes'

#
# Include common recipes.
#

include_recipe 'annoyances::default'
include_recipe 'core::_users'
include_recipe 'apt::default' if platform_family? 'debian'
include_recipe 'logrotate::default'
include_recipe 'ntp::default'
include_recipe 'timezone-ii::default'
include_recipe 'zsh::default'
include_recipe 'vim::default'
include_recipe 'sudo::default'
include_recipe 'openssh::default'
include_recipe 'oh-my-zsh::default'

#
# Install additional packages.
#

node['core']['packages'].each do |pkg|
  package pkg do
    action :install
  end
end

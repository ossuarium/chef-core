#
# Cookbook Name:: otr
# Recipe:: _users
#

include_recipe 'users::default'
include_recipe 'users::sysadmins'

#
# Setup deployer user.
#

user node['otr']['deployer']['user'] do
  shell '/bin/bash'
  home node['otr']['deployer']['home_dir']
  system true
  supports manage_home: true
end

#
# Create and add uses to the deployers group.
#

users_manage node['otr']['deployers']['name'] do
  group_id node['otr']['deployers']['gid']
  action [:remove, :create]
end

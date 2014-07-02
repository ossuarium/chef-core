#
# Cookbook Name:: otr
# Recipe:: _users
#

include_recipe 'users::default'
include_recipe 'users::sysadmins'

#
# Create and add uses to the deployers group.
#

users_manage node['otr']['deployers']['name'] do
  group_id node['otr']['deployers']['gid']
  action [:remove, :create]
end

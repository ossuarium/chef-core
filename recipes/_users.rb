#
# Cookbook Name:: core
# Recipe:: _users
#

include_recipe 'users::default'
include_recipe 'users::sysadmins'

#
# Setup deployer user.
#

user node['core']['deployer']['user'] do
  shell '/bin/bash'
  home node['core']['deployer']['home_dir']
  system true
  supports manage_home: true
end

# Must create the apps directory now.
directory "#{node['core']['deployer']['home_dir']}/apps" do
  owner node['core']['deployer']['user']
  group node['core']['deployer']['user']
  mode '0750'
end

#
# Create and add uses to the deployers group.
#

users_manage node['core']['deployers']['name'] do
  group_id node['core']['deployers']['gid']
  action [:remove, :create]
end

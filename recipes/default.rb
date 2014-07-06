#
# Cookbook Name:: core
# Recipe:: default
#

include_recipe 'core::_common_system' if node['core']['common_system']

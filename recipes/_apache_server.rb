#
# Cookbook Name:: otr
# Recipe:: _apache_server
#

node.set['apache']['version'] = '2.4' if
  platform?('ubuntu') && node['platform_version'].to_f >= 14.04

node.default['apache']['default_site_enabled']  = false

include_recipe 'apache2::default'

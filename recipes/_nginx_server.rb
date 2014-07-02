#
# Cookbook Name:: otr
# Recipe:: _nginx_server
#

node.default['otr']['servers']['http'] = true
node.default['otr']['servers']['https'] = true

node.default['nginx']['default_site_enabled'] = false

include_recipe 'nginx::default'

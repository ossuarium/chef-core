#
# Cookbook Name:: otr
# Recipe:: _nginx_server
#

node.default['nginx']['default_site_enabled'] = false

include_recipe 'nginx::default'

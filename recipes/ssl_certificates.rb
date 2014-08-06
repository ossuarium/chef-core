#
# Cookbook Name:: core
# Recipe:: ssl_certificates
#

node.default['ssl']['group'] = node['root_group']

include_recipe 'ssl::default'

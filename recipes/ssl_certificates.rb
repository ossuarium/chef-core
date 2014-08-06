#
# Cookbook Name:: core
# Recipe:: ssl_certificates
#

node.default['ssl']['group'] = 'root'

include_recipe 'ssl::default'

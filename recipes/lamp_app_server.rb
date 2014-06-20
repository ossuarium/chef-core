#
# Cookbook Name:: otr
# Recipe:: lamp_app_server
#

node.default['otr']['servers']['http'] = true
node.default['otr']['servers']['https'] = true

include_recipe 'otr::_common_system'
include_recipe 'otr::_apache_server'
include_recipe 'apache2::mod_fastcgi'
include_recipe 'mysql::client'
include_recipe 'database::mysql'
include_recipe 'php::default'
include_recipe 'php::fpm'
include_recipe 'php::module_mysql'

apache_module 'actions' do
  enable true
end

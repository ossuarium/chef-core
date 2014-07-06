#
# Cookbook Name:: core
# Recipe:: lamp_app_server
#

=begin
#<
This installs the Apache HTTP Server, MySQL client, PHP-FPM,
and the necessary modules to host a PHP application using mod_fastcgi.

This also installs the [database cookbook].

[database cookbook]: http://community.opscode.com/cookbooks/database
#>
=end

node.default['core']['servers']['http'] = true
node.default['core']['servers']['https'] = true

node.default['build-essential']['compile_time'] = true
node.default['php-fpm']['pools'] = []

include_recipe 'core::_common_system' if node['core']['common_system']
include_recipe 'core::_apache_server'
include_recipe 'apache2::mod_fastcgi'
include_recipe 'mysql::client'
include_recipe 'database::mysql'
include_recipe 'php::default'
include_recipe 'php-fpm::default'
include_recipe 'php::module_mysql'
include_recipe 'core::services'

apache_module 'actions' do
  enable true
end

node['core']['apps'].select { |a| a[:type] == 'lamp' }.each do |app|
  core_lamp_app app[:name] do
    moniker app[:moniker]
    service lazy { resources(core_service: app[:service]) }
    action app[:action] if app[:action]
  end
end

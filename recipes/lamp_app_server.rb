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
include_recipe 'nfs::client4'
include_recipe 'core::_apache_server'
include_recipe 'apache2::mod_fastcgi'
include_recipe 'apache2::mod_ssl' if node['core']['ssl']
include_recipe 'mysql::client'
include_recipe 'database::mysql'
include_recipe 'php::default'
include_recipe 'php::module_mysql'
include_recipe 'php-modules::default'
include_recipe 'php-fpm::default'
include_recipe 'core::services'

directory "#{node['core']['log_dir']}/php" do
  group node['apache']['group']
  mode '0775'
end

logrotate_app 'apache2-vhosts' do
  path "#{node['apache']['log_dir']}/*.log"
end

logrotate_app 'php-fpm-pools' do
  path "#{node['php-fpm']['log_dir']}/*.log"
end

logrotate_app 'php' do
  path "#{node['core']['log_dir']}/php/*.log"
end

apache_module 'actions' do
  enable true
end

node['core']['apps'].select { |_, v| v[:type] == 'lamp' }.each do |app, params|
  core_lamp_app app do
    moniker params[:moniker]
    service lazy { resources(core_service: params[:service]) }
    fpm params[:fpm] if params[:fpm]
    database params[:database] if params[:database]
    shared params[:shared] if params[:shared]
    storage params[:storage] if params[:storage]
    action params[:action] if params[:action]
  end
end

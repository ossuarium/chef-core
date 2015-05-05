#
# Cookbook Name:: core
# Recipe:: mysql_server
#

=begin
#<
This will configure a MySQL server and optionally
setup phpMyAdmin running on Apache using FastCGI and PHP-FPM.
#>
=end

::Chef::Recipe.send :include, Opscode::OpenSSL::Password

node.set_unless['core']['mysql_root_password'] = secure_password
node.set_unless['core']['mysql_sudoroot_password'] = secure_password

node.default['core']['servers']['mysql'] = true

node.default['core']['servers']['http'] = node['core']['mysql_admin']
node.default['core']['servers']['https'] = node['core']['mysql_admin']

include_recipe 'core::_common_system' if node['core']['common_system']

mysql_service node['core']['mysql_instance'] do
  port node['core']['mysql_port']
  version node['core']['mysql_version']
  initial_root_password node['core']['mysql_root_password']
  action [:create, :start]
end

mysql_client 'default' do
  action :create
end

mysql2_chef_gem 'default' do
  action :install
end

include_recipe 'phpmyadmin::default' if node['core']['mysql_admin']

mysql_database_user node['core']['mysql_sudoroot_user'] do
  connection host: 'localhost',
             socket: "#{node['core']['run_dir']}/mysql-#{node['core']['mysql_instance']}/mysqld.sock",
             username: 'root',
             password: node['core']['mysql_root_password']
  password node['core']['mysql_sudoroot_password']
  host Chef::Recipe::PrivateNetwork.new(node).subnet
  grant_option true
  action [:create, :grant]
end

service 'apache2' do
  action node['core']['mysql_admin'] ? :start : :stop
  not_if { node['apache2'].empty? }
end

core_service 'mysql_admin' do
  only_if { node['core']['mysql_admin'] }
end

phpmyadmin 'mysql_admin' do
  service resources('core_service[mysql_admin]')
  alias_path node['core']['mysql_admin_alias_path'] if node['core']['mysql_admin_alias_path']
  ssl true if node['core']['mysql_admin_ssl']
  vhost true if node['core']['mysql_admin_subdomain']
  domain "#{node['core']['mysql_admin_subdomain']}.#{node['hostname']}" if
    node['core']['mysql_admin_subdomain']
  only_if { node['core']['mysql_admin'] }
end

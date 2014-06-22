#
# Cookbook Name:: otr
# Recipe:: mysql_server
#

=begin
#<
This will configure a MySQL server and optionally
setup phpMyAdmin running on Nginx using FastCGI and PHP-FPM.
#>
=end

::Chef::Recipe.send :include, Opscode::OpenSSL::Password

node.set_unless['mysql']['server_root_password'] = secure_password

node.default['otr']['servers']['mysql'] = true

if node['otr']['mysql_admin']
  node.default['otr']['servers']['http'] = true
  node.default['otr']['servers']['https'] = true
end

include_recipe 'otr::_common_system'
include_recipe 'mysql::server'
include_recipe 'otr::_mysql_admin' if node['otr']['mysql_admin']

service 'nginx' do
  action node['otr']['mysql_admin'] ? :start : :stop
  not_if node['nginx'].empty?
end

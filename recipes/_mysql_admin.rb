#
# Cookbook Name:: otr
# Recipe:: _mysql_admin
#

::Chef::Recipe.send :include, Opscode::OpenSSL::Password

node.default['phpmyadmin']['socket'] = "#{node['otr']['run_dir']}/php-fpm-phpmyadmin.sock"

node.set_unless['otr']['phpmyadmin']['pma_password'] = secure_password

include_recipe 'mysql::client'
include_recipe 'otr::_nginx_server'
include_recipe 'php::default'
include_recipe 'php::fpm'
include_recipe 'phpmyadmin::default'

template "#{node['nginx']['dir']}/sites-available/phpmyadmin" do
  source 'nginx-phpmyadmin.conf.erb'
  notifies :reload, 'service[nginx]'
end

nginx_site 'phpmyadmin' do
  enable node['otr']['mysql_admin']
end

phpmyadmin_pmadb 'phpmyadmin' do
  host node['hostname']
  port node['mysql']['port'].to_i
  root_username 'root'
  root_password node['mysql']['server_root_password']
  pma_database node['otr']['phpmyadmin']['pma_database']
  pma_username node['otr']['phpmyadmin']['pma_username']
  pma_password node['otr']['phpmyadmin']['pma_password']
end

phpmyadmin_db node['hostname'] do
  host node['hostname']
  port node['mysql']['port'].to_i
  username 'root'
  password node['mysql']['server_root_password']
  pma_database node['otr']['phpmyadmin']['pma_database']
  pma_username node['otr']['phpmyadmin']['pma_username']
  pma_password node['otr']['phpmyadmin']['pma_password']
  auth_type 'cookie'
  hide_dbs %w(information_schema mysql phpmyadmin performance_schema)
end

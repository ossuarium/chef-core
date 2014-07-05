#
# Cookbook Name:: core
# Recipe:: _nginx_server
#

node.default['nginx']['default_site_enabled'] = false

include_recipe 'nginx::default'

template "#{node['nginx']['dir']}/conf.d/core.conf" do
  source 'nginx-core.conf.erb'
  notifies :reload, 'service[nginx]'
end

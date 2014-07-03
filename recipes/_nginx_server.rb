#
# Cookbook Name:: otr
# Recipe:: _nginx_server
#

node.default['nginx']['default_site_enabled'] = false

include_recipe 'nginx::default'

template "#{node['nginx']['dir']}/conf.d/000-otr.conf" do
  source 'nginx-otr.conf.erb'
  notifies :reload, 'service[nginx]'
end

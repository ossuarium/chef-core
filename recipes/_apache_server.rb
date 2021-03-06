#
# Cookbook Name:: core
# Recipe:: _apache_server
#

apache24 = platform?('ubuntu') && node['platform_version'].to_f >= 14.04

node.default['apache']['default_site_enabled']  = false
node.default['apache']['contact'] = node['core']['contact']

if apache24
  node.set['apache']['version']  = '2.4'
  node.set['apache']['pid_file'] = '/var/run/apache2/apache2.pid'
  node.set['apache']['mpm'] = 'event'
  node.set['apache']['event']['maxrequestworkers'] =
    node['core']['lamp']['thread_multiplier'] * node['apache']['worker']['threadsperchild']
end

include_recipe 'apache2::default'
include_recipe 'apache2::logrotate'

template "#{node['apache']['dir']}/conf-available/core.conf" do
  source 'apache-core.conf.erb'
  notifies :reload, 'service[apache2]'
end

apache_config 'core'

apache_module 'access_compat' do
  enable false
end if apache24

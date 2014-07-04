#
# Cookbook Name:: otr
# Recipe:: _apache_server
#

node.default['otr']['servers']['http'] = true
node.default['otr']['servers']['https'] = true

apache24 = platform?('ubuntu') && node['platform_version'].to_f >= 14.04

if apache24
  node.set['apache']['pid_file'] = '/var/run/apache2/apache2.pid'
  node.set['apache']['version']  = '2.4'
end

include_recipe 'apache2::default'
include_recipe 'apache2::logrotate'

template "#{node['apache']['dir']}/conf.d/000-otr.conf" do
  source 'apache-otr.conf.erb'
  notifies :reload, 'service[apache2]'
end

apache_module 'access_compat' do
  enable false
  only_if { apache24 }
end

# This is required to avoid conflicting security.conf files.
# @todo Remove this when [apache2 issue 131] is closed.
# [apache2 issue 131]: https://github.com/onehealth-cookbooks/apache2/issues/131
execute 'a2disconf security' do
  notifies :reload, 'service[apache2]'
  only_if { apache24 }
end

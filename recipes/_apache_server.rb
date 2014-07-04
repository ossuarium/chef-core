#
# Cookbook Name:: otr
# Recipe:: _apache_server
#

node.default['otr']['servers']['http'] = true
node.default['otr']['servers']['https'] = true

if platform?('ubuntu') && node['platform_version'].to_f >= 14.04
  node.set['apache']['pid_file'] = '/var/run/apache2/apache2.pid'
  node.set['apache']['version']  = '2.4'
end

include_recipe 'apache2::default'

template "#{node['apache']['dir']}/conf.d/000-otr.conf" do
  source 'apache-otr.conf.erb'
  notifies :reload, 'service[apache2]'
end

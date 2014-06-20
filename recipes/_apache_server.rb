#
# Cookbook Name:: otr
# Recipe:: _apache_server
#

node.default['apache']['default_site_enabled'] = false

if platform?('ubuntu') && node['platform_version'] == '14.04'
  node.default['apache']['version'] = '2.4'
end

include_recipe 'apache2::default'

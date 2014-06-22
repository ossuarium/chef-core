#
# Cookbook Name:: otr
# Recipe:: _apache_server
#

node.default['apache']['default_site_enabled'] = false

if platform?('ubuntu') && node['platform_version'] == '14.04'
  node.default['apache']['version'] = '2.4'
end

include_recipe 'apache2::default'

# This is required to enable or disable the default site on Ubuntu 14.04.
# @todo Remove this when [apache2 issue 146] is closed.
# [apache2 issue 146]: https://github.com/onehealth-cookbooks/apache2/issues/146
apache_site '000-default.conf' do
  enable node['apache']['default_site_enabled']
end

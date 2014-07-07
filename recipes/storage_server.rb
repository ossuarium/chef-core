#
# Cookbook Name:: core
# Recipe:: storage_server
#

node.default['core']['servers']['nfs'] = true

include_recipe 'core::_common_system' if node['core']['common_system']
include_recipe 'core::_nfs_server'

directory node['core']['storage_dir']

node['core']['storage'].each do |storage|
  directory "#{node['core']['storage_dir']}/#{storage[:name]}"

  storage[:paths].each do |path|
    directory "#{node['core']['storage_dir']}/#{storage[:name]}/#{path}" do
      group storage[:group].nil? ? node['apache']['group'] : storage[:group]
      mode '0775'
      recursive true
    end
  end unless storage[:paths].nil?

  nfs_export "#{node['core']['storage_dir']}/#{storage[:name]}" do
    network PrivateNetwork.new(node).subnet
    writeable storage[:writeable] unless storage[:writeable].nil?
    sync true
    options ['root_squash']
  end
end

#
# Cookbook Name:: core
# Recipe:: storage_server
#

node.default['core']['servers']['nfs'] = true

include_recipe 'core::_common_system' if node['core']['common_system']
include_recipe 'nfs::server4'

directory node['core']['storage_dir']

node['core']['storage'].each do |storage, params|
  directory "#{node['core']['storage_dir']}/#{storage}"

  params[:paths].each do |path|
    directory "#{node['core']['storage_dir']}/#{storage}/#{path}" do
      group params[:group].nil? ? node['apache']['group'] : params[:group]
      mode '0775'
      recursive true
    end
  end unless params[:paths].nil?

  nfs_export "#{node['core']['storage_dir']}/#{storage}" do
    network PrivateNetwork.new(node).subnet
    writeable params[:writeable] unless params[:writeable].nil?
    sync true
    options ['root_squash']
  end
end

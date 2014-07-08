#
# Cookbook Name:: core
# Recipe:: storage_server
#

node.default['core']['servers']['nfs'] = true

node.set_unless['core']['exports'] = {}

include_recipe 'core::_common_system' if node['core']['common_system']
include_recipe 'partial_search::default'
include_recipe 'nfs::server4'

directory node['core']['storage_dir']

old_exports = node['core']['exports']
new_exports = {}

node['core']['storage'].each do |storage, params|
  new_exports[storage] = {}

  directory "#{node['core']['storage_dir']}/#{storage}" do
    group params[:group].nil? ? node['core']['storage_group'] : params[:group]
    mode '0775'
  end

  nodes = partial_search(
    :node,
    "chef_environment:#{node.chef_environment} AND core_storage_access_#{storage}_readable:true",
    keys: {
      'network' => ['network'],
      'core' => ['core']
    }
  )

  nodes.each do |n|
    ip = PrivateNetwork.new(n).ip
    access = n['core']['storage_access'][storage]
    new_exports[storage][ip] = access

    nfs_export "#{node['core']['storage_dir']}/#{storage}" do
      network ip
      writeable access['writeable'] unless access['writeable'].nil?
      sync true
      options ['root_squash']
      only_if { access['readable'] }
    end
  end
end

node.set['core']['exports'] = new_exports

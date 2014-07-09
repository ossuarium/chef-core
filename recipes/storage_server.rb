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

execute "rm #{node['core']['exports_conf']}" do
  only_if { ::File.exist?(node['core']['exports_conf']) }
end

node['core']['storage'].each do |storage, params|
  directory "#{node['core']['storage_dir']}/#{storage}" do
    group params[:group].nil? ? node['core']['storage_group'] : params[:group]
    mode '0775'
  end

  nodes = partial_search(
    :node,
    "chef_environment:#{node.chef_environment}" \
    " AND core_storage_access_#{storage}_readable:true",
    keys: {'network' => ['network'], 'core' => ['core']}
  )

  nodes.each do |n|
    ip = PrivateNetwork.new(n).ip
    access = n['core']['storage_access'][storage]

    nfs_export "#{node['core']['storage_dir']}/#{storage}" do
      network ip
      writeable access['writeable'].nil? ? false : access['writeable']
      sync true
      options ['root_squash']
      only_if { params[:enabled] && access['readable'] }
    end
  end
end

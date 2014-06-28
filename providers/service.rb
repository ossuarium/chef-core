#
# Cookbook Name:: otr
# Provider:: service
#

def whyrun_supported?
  true
end

action :create do
  converge_by("Creating #{@new_resource}") do
    create_service
  end
end

action :delete do
  converge_by("Deleting #{@new_resource}") do
    delete_service
  end
end

private

def set_attributes
  name = new_resource.name
  new_resource.dir = "#{node['otr']['srv_dir']}/#{name}"
  new_resource.apache_conf_dir =
    "#{node['apache']['dir']}/services/#{name}" unless node['apache'].nil?
end

def create_service
  set_attributes

  # Create `/srv/name`.
  directory new_resource.dir do
    owner 'root'
    group node['otr']['deployer']['user']
    mode '0775'
    action :create
  end

  # Create `/srv/name/shared`, etc.
  node['otr']['service']['dirs'].each do |path|
    directory "#{new_resource.dir}/#{path}" do
      owner 'root'
      group node['otr']['deployer']['user']
      mode '0775'
      action :create
    end
  end

  # Create `/etc/apache2/services`.
  directory "#{node['apache']['dir']}/services" do
    owner 'root'
    group node['root_group']
    mode '0755'
    action :create
    only_if { Dir.exist?(node['apache']['dir']) }
  end

  # Create `/etc/apache2/services/name`.
  directory new_resource.apache_conf_dir do
    owner 'root'
    group node['root_group']
    mode '0755'
    action :create
    only_if { Dir.exist?(node['apache']['dir']) }
  end
end

def delete_service
  set_attributes

  # Delete `/srv/name`.
  directory new_resource.dir do
    recursive true
    action :delete
  end

  # Delete (if empty) `/etc/apache2/services/name`.
  directory new_resource.apache_conf_dir do
    recursive true
    action :delete
    only_if { Dir.exist?(node['apache']['dir']) }
  end

  # Delete `/etc/apache2/services`.
  directory "#{node['apache']['dir']}/services" do
    action :delete
    only_if { Dir["#{node['apache']['dir']}/services/*"].empty? }
  end
end

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
  new_resource.dir = "#{node['otr']['srv_dir']}/#{new_resource.name}"
  new_resource.nginx_conf_dir =
    "#{node['nginx']['dir']}/services/#{new_resource.name}" unless node['nginx'].nil?
  new_resource.apache_conf_dir =
    "#{node['apache']['dir']}/services/#{new_resource.name}" unless node['apache'].nil?
end

def create_service
  set_attributes

  # Create `/srv/name`.
  directory new_resource.dir do
    owner 'root'
    group node['otr']['deployer']['user']
    mode '0775'
  end

  # Create `/srv/name/shared`, etc.
  node['otr']['service']['dirs'].each do |path|
    directory "#{new_resource.dir}/#{path}" do
      owner 'root'
      group node['otr']['deployer']['user']
      mode '0775'
    end
  end

  # Create `/etc/nginx/services`.
  directory "#{node['nginx']['dir']}/services" do
    owner 'root'
    group node['root_group']
    mode '0755'
    only_if { Dir.exist?(node['nginx']['dir']) }
  end

  # Create `/etc/apache2/services`.
  directory "#{node['apache']['dir']}/services" do
    owner 'root'
    group node['root_group']
    mode '0755'
    only_if { Dir.exist?(node['apache']['dir']) }
  end

  # Create `/etc/nginx/services/name`.
  directory new_resource.nginx_conf_dir do
    owner 'root'
    group node['root_group']
    mode '0755'
    only_if { Dir.exist?(node['nginx']['dir']) }
  end

  # Create `/etc/apache2/services/name`.
  directory new_resource.apache_conf_dir do
    owner 'root'
    group node['root_group']
    mode '0755'
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

  # Delete (if empty) `/etc/nginx/services/name`.
  directory new_resource.nginx_conf_dir do
    recursive true
    action :delete
    only_if { Dir.exist?(node['nginx']['dir']) }
  end

  # Delete (if empty) `/etc/apache2/services/name`.
  directory new_resource.apache_conf_dir do
    recursive true
    action :delete
    only_if { Dir.exist?(node['apache']['dir']) }
  end

  # Delete `/etc/nginx/services`.
  directory "#{node['nginx']['dir']}/services" do
    action :delete
    only_if { Dir["#{node['nginx']['dir']}/services/*"].empty? }
  end

  # Delete `/etc/apache2/services`.
  directory "#{node['apache']['dir']}/services" do
    action :delete
    only_if { Dir["#{node['apache']['dir']}/services/*"].empty? }
  end
end

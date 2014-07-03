#
# Cookbook Name:: otr
# Provider:: static_app
#

include Opscode::OpenSSL::Password

def whyrun_supported?
  true
end

action :create do
  converge_by("Creating #{@new_resource}") do
    create_static_app
  end
end

action :delete do
  converge_by("Deleting #{@new_resource}") do
    delete_static_app
  end
end

private

def set_attributes
  new_resource.type = :static
  new_resource.group = node['nginx']['group']
  new_resource.dir = "#{new_resource.service.dir}/#{new_resource.moniker}"
  new_resource.conf_dir = "#{new_resource.service.nginx_conf_dir}/#{new_resource.moniker}.d"
end

def create_static_app
  set_attributes

  fail 'No nginx conf directory.' if new_resource.service.nginx_conf_dir.nil?

  # Create `/etc/nginx/services/service_name/moniker.d`.
  directory "static_app_#{new_resource.conf_dir}" do
    path new_resource.conf_dir
    notifies :reload, 'service[nginx]'
  end
end

def delete_static_app
  set_attributes

  # Delete `/etc/nginx/services/service_name/moniker.d`.
  directory "static_app_#{new_resource.conf_dir}" do
    path new_resource.conf_dir
    recursive true
    action :delete
    notifies :reload, 'service[nginx]'
    only_if { Dir.exist?(new_resource.conf_dir) }
  end
end

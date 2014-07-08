#
# Cookbook Name:: core
# Provider:: lamp_app
#

require 'digest/sha1'

include Opscode::OpenSSL::Password

def whyrun_supported?
  true
end

action :create do
  converge_by("Creating #{@new_resource}") do
    create_lamp_app
  end
end

action :delete do
  converge_by("Deleting #{@new_resource}") do
    delete_lamp_app
  end
end

action :destroy do
  converge_by("Destroying #{@new_resource}") do
    delete_lamp_app
    destroy_lamp_app
  end
end

private

def set_attributes
  new_resource.db_name ||= new_resource.name[0...64]
  new_resource.db_user ||= Digest::SHA1.hexdigest(new_resource.name)[0...16]
  new_resource.db_password ||= secure_password
  new_resource.db_client ||= Chef::Recipe::PrivateNetwork.new(node).ip

  new_resource.type = :lamp
  new_resource.group = node['apache']['group']
  new_resource.dir = "#{new_resource.service.dir}/#{new_resource.moniker}"
  new_resource.conf_dir = "#{new_resource.service.apache_conf_dir}/#{new_resource.moniker}.d"
  new_resource.shared_dir = "#{new_resource.service.dir}/shared/#{new_resource.moniker}"
  new_resource.fpm_socket_path =
    if new_resource.fpm_pool.nil?
      "#{node['core']['run_dir']}/php-fpm-lamp_app_#{new_resource.name}.sock"
    else
      "#{node['core']['run_dir']}/php-fpm-#{new_resource.fpm_pool.variables[:pool_name]}.sock"
    end
end

def set_mysql_connection
  db_node = partial_search(
    :node,
    "chef_environment:#{node.chef_environment} AND tags:mysql-master",
     keys: {
      'network' => ['network'],
      'core' => ['core']
    }
  ).first
  new_resource.mysql_connection ||= {
    host: Chef::Recipe::PrivateNetwork.new(db_node).ip,
    username: db_node['core']['mysql_sudoroot_user'],
    password: db_node['core']['mysql_sudoroot_password']
  }
end

def storage_host(storage)
  '10.10.10.100'
end

def create_lamp_app
  set_attributes
  set_mysql_connection

  fail 'No apache conf directory.' if new_resource.service.apache_conf_dir.nil?

  # Create `/srv/service_name/shared/moniker`.
  directory "lamp_app_#{new_resource.shared_dir}" do
    path new_resource.shared_dir
    group new_resource.group
    mode '0750'
  end

  # Create shared directories.
  new_resource.shared.each do |path|
    directory "lamp_app_#{new_resource.shared_dir}/#{path}" do
      path "#{new_resource.shared_dir}/#{path}"
      owner node['apache']['user']
      group new_resource.group
      mode '0750'
      recursive true
    end
  end

  # Mount storage directories.
  new_resource.storage.each do |storage, params|
    directory "lamp_app_#{new_resource.shared_dir}/#{params[:path]}" do
      path "#{new_resource.shared_dir}/#{params[:path]}"
      recursive true
      not_if { Dir.exist?("#{new_resource.shared_dir}/#{params[:path]}") }
    end

    mount "lamp_app_#{new_resource.shared_dir}/#{params[:path]}" do
      mount_point "#{new_resource.shared_dir}/#{params[:path]}"
      device(
        "#{storage_host(storage)}:#{node['core']['storage_dir']}/#{storage}"
      )
      fstype 'nfs'
      options params[:options]
    end
  end

  # Create the PHP-FPM socket if not explicitly given.
  php_fpm_pool "lamp_app_#{new_resource.name}" do
    socket true
    only_if { new_resource.fpm_pool.nil? }
  end

  # Create `/usr/lib/cgi-bin/name`.
  directory "#{node['apache']['cgibin_dir']}/#{new_resource.name}" do
    only_if { new_resource.fpm }
  end

  # Create `/etc/apache2/services/service_name/moniker.d`.
  directory "lamp_app_#{new_resource.conf_dir}" do
    path new_resource.conf_dir
    notifies :reload, 'service[apache2]'
  end

  # Create an apache configuration fragment for the FCGI connection.
  template "#{new_resource.conf_dir}/php-fcgi.conf" do
    source 'apache-php-fcgi.conf.erb'
    cookbook 'core'
    variables(
      name: new_resource.name,
      socket: new_resource.fpm_socket_path,
      docroot: new_resource.dir
    )
    notifies :reload, 'service[apache2]'
    only_if { new_resource.fpm }
  end

  # Create the database for the LAMP app.
  mysql_database "lamp_app_#{new_resource.db_name}" do
    database_name new_resource.db_name
    connection new_resource.mysql_connection
    encoding 'utf8'
    collation 'utf8_unicode_ci'
    only_if { new_resource.database }
  end

  # Create the LAMP app's MySQL user for this host.
  mysql_database_user "lamp_app_#{new_resource.db_user}" do
    username new_resource.db_user
    connection new_resource.mysql_connection
    password new_resource.db_password
    database_name new_resource.db_name
    host new_resource.db_client
    action [:drop, :create, :grant]
    only_if { new_resource.database }
  end
end

def delete_lamp_app
  set_attributes
  set_mysql_connection

  # Unmount storage directories.
  new_resource.storage.each do |storage, params|
    mount "lamp_app_#{new_resource.shared_dir}/#{params[:path]}" do
      mount_point "#{new_resource.shared_dir}/#{params[:path]}"
      action :umount
    end
  end

  # Delete `/etc/apache2/services/service_name/moniker.d`.
  directory "lamp_app_#{new_resource.conf_dir}" do
    path new_resource.conf_dir
    recursive true
    action :delete
    notifies :reload, 'service[apache2]'
    only_if { Dir.exist?(new_resource.conf_dir) }
  end

  # Remove PHP-FPM socket if it shares the LAMP app name.
  php_fpm_pool "lamp_app_#{new_resource.name}" do
    socket true
    action :delete
    only_if { new_resource.fpm_pool.nil? }
  end

  # Delete `/usr/lib/cgi-bin/name`.
  directory "#{node['apache']['cgibin_dir']}/php5-#{new_resource.name}" do
    action :delete
    only_if { new_resource.fpm }
  end

  # Remove the LAMP app's MySQL user for this host.
  mysql_database_user "lamp_app_#{new_resource.db_user}" do
    username new_resource.db_user
    connection new_resource.mysql_connection
    host new_resource.db_client
    action :drop
    only_if { new_resource.database }
  end
end

def destroy_lamp_app
  set_attributes
  set_mysql_connection

  # Delete `/srv/service_name/shared/moniker`.
  directory "lamp_app_#{new_resource.shared_dir}" do
    path new_resource.shared_dir
    recursive true
    action :delete
  end

  # Delete the database for the LAMP app.
  mysql_database "lamp_app_#{new_resource.db_name}" do
    database_name new_resource.db_name
    connection new_resource.mysql_connection
    action :drop
    only_if { new_resource.database }
  end
end

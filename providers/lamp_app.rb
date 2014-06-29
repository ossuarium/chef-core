#
# Cookbook Name:: otr
# Provider:: lamp_app
#

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

private

def set_attributes
  new_resource.fpm_socket ||= new_resource.name
  new_resource.db_name ||= new_resource.name
  new_resource.db_user ||= new_resource.name
  new_resource.db_password ||= secure_password

  new_resource.dir = "#{new_resource.service.dir}/#{new_resource.moniker}"
  new_resource.conf_dir = "#{new_resource.service.apache_conf_dir}/#{new_resource.moniker}.d"
  new_resource.fpm_socket_path = "#{node['otr']['run_dir']}/#{new_resource.fpm_socket}.sock"
end

def create_lamp_app
  set_attributes

  fail 'No apache conf directory.' if new_resource.service.apache_conf_dir.nil?

  # Create the PHP-FPM socket if not explicitly given.
  php_fpm "lamp_app_#{new_resource.fpm_socket}" do
    user node['apache']['user']
    group node['apache']['group']
    socket true
    socket_path new_resource.fpm_socket_path
    action :add
    only_if { new_resource.fpm_socket == new_resource.name }
  end

  # Create `/etc/apache2/services/service_name/moniker.d`.
  directory "lamp_app_#{new_resource.conf_dir}" do
    path new_resource.conf_dir
    owner 'root'
    group node['root_group']
    mode '0755'
    action :create
    notifies :reload, 'service[apache2]'
  end

  # Create an apache configuration fragment for the FCGI connection.
  template "#{new_resource.conf_dir}/php-fcgi.conf" do
    source 'apache-php-fcgi.conf.erb'
    cookbook 'otr'
    owner 'root'
    group node['root_group']
    mode '0644'
    variables(
      socket: new_resource.fpm_socket_path
    )
    notifies :reload, 'service[apache2]'
  end

  # Create the database for the LAMP app.
  mysql_database "lamp_app_#{new_resource.db_name}" do
    database_name new_resource.db_name[0...64]
    connection new_resource.mysql_connection
    encoding 'utf8'
    collation 'utf8_unicode_ci'
    action :create
    not_if { new_resource.mysql_connection.empty? }
  end

  # Create the LAMP app's MySQL user for this host.
  mysql_database_user "lamp_app_#{new_resource.db_user}" do
    username new_resource.db_user[0...16]
    connection new_resource.mysql_connection
    password new_resource.db_password
    database_name new_resource.db_name
    host new_resource.db_client
    action [:drop, :create, :grant]
    not_if { new_resource.mysql_connection.empty? }
  end
end

def delete_lamp_app
  set_attributes

  # Delete `/etc/apache2/services/service_name/moniker.d`.
  directory "lamp_app_#{new_resource.conf_dir}" do
    path new_resource.conf_dir
    recursive true
    action :delete
    notifies :reload, 'service[apache2]'
    only_if { Dir.exist?(new_resource.conf_dir) }
  end

  # Remove PHP-FPM socket if it shares the LAMP app name.
  php_fpm "lamp_app_#{new_resource.fpm_socket}" do
    user node['apache']['user']
    group node['apache']['group']
    socket true
    socket_path new_resource.fpm_socket_path
    action :remove
    only_if { new_resource.fpm_socket == new_resource.name }
  end

  # Remove the LAMP app's MySQL user for this host.
  mysql_database_user "lamp_app_#{new_resource.db_user}" do
    username new_resource.db_user[0...16]
    connection new_resource.mysql_connection
    host new_resource.db_client
    action :drop
    not_if { new_resource.mysql_connection.empty? }
  end
end

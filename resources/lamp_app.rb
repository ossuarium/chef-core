#
# Cookbook Name:: core
# Resource:: lamp_app
#

=begin
#<
Each LAMP app must be assigned a `core_service`.

@action create creates the LAMP app.
@action delete deletes the LAMP app.

@attribute name the unique name of the LAMP app.
@attribute moniker the name of the LAMP app.
@attribute service the service to crate the LAMP app under.
@attribute fpm_socket path to the externally managed FPM socket to use.
@attribute fpm whether to setup an FPM socket for this app.
@attribute mysql_connection MySQL admin connection information.
@attribute database whether to setup a database for this app.
@attribute db_name database name to use for the LAMP app.
@attribute db_user MySQL username to use to connect to the database.
@attribute db_password MySQL password to use to connect to the database.
@attribute db_client host part of the MySQL username to use when creating the user.
#>
=end

default_action :create

actions :create, :delete

attribute :name, kind_of: String, required: true, name_attribute: true
attribute :moniker, kind_of: String, required: true
attribute :service, kind_of: Chef::Resource, required: true
attribute :fpm, kind_of: [TrueClass, FalseClass], default: true
attribute :fpm_socket, kind_of: String
attribute :database, kind_of: [TrueClass, FalseClass], default: false
attribute :mysql_connection, kind_of: Hash
attribute :db_name, kind_of: String
attribute :db_user, kind_of: String
attribute :db_password, kind_of: String
attribute :db_client, kind_of: String

attr_accessor :type, :dir, :conf_dir, :shared_path, :fpm_socket_path, :group

attr_writer :fpm_socket, :mysql_connection,
            :db_name, :db_user, :db_password, :db_client

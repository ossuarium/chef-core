#
# Cookbook Name:: core
# Resource:: static_app
#

=begin
#<
Each static app must be assigned a `core_service`.

@action create creates the static app.
@action delete deletes the static app.

@attribute name the unique name of the static app.
@attribute moniker the name of the static app.
@attribute service the service to crate the static app under.
#>
=end

default_action :create

actions :create, :delete

attribute :name, kind_of: String, required: true, name_attribute: true
attribute :moniker, kind_of: String, required: true
attribute :service, kind_of: Chef::Resource, required: true

attr_accessor :type, :dir, :conf_dir, :group, :shared_dir

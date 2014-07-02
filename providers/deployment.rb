#
# Cookbook Name:: otr
# Provider:: deployment
#

def whyrun_supported?
  true
end

action :create do
  converge_by("Creating #{@new_resource}") do
    create_deployment
  end
end

action :delete do
  converge_by("Deleting #{@new_resource}") do
    delete_deployment
  end
end

private

def deployment_users
  search 'users', "groups:deployment-#{new_resource.name} AND NOT action:remove"
end

def create_deployment
  template "#{node['otr']['deployer']['home_dir']}/deployment-#{new_resource.name}.yml" do
    source 'deployment.yml.erb'
    cookbook 'otr'
    owner node['otr']['deployer']['user']
    group node['otr']['deployer']['user']
    mode '0755'
    variables(
      name: new_resource.name,
      apps: new_resource.apps
    )
  end

  deployment_users.each do |user|
    bin = "#{node['otr']['deployer']['home_dir']}/bin"
    script = "deploy-#{new_resource.name}-#{user.id}"

    template "#{bin}/#{script}" do
      source 'deployment.sh.erb'
      cookbook 'otr'
      owner node['otr']['deployer']['user']
      group node['otr']['deployer']['user']
      mode '0755'
      variables(
        name: new_resource.name,
        user: user.id,
        deployments_dir:
          "#{node['otr']['home_dir']}/#{user.id}/" +
          node['otr']['deployers']['deployments_dir'],
        apps: new_resource.apps
      )
    end

    sudo script do
      user user.id
      nopasswd true
      runas node['otr']['deployer']['user']
      commands ["#{bin}/#{script}"]
    end
  end
end

def delete_deployment
  scripts = "deploy-#{new_resource.name}-*"

  Dir["#{node['authorization']['sudo']['prefix']}/sudoers.d/#{scripts}"]
  .each { |f| File.unlink f }

  Dir["#{node['otr']['deployer']['home_dir']}/bin/#{scripts}"]
  .each { |f| File.unlink f }

  file "#{node['otr']['deployer']['home_dir']}/deployment-#{new_resource.name}.yml" do
    action :delete
  end
end

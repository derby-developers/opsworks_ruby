# frozen_string_literal: true
include_recipe 'opsworks_ruby::configure'

every_enabled_application do |application, _deploy|
  scm = Drivers::Scm::Factory.build(application, node)
  scm.before_deploy(self)

  deploy application['shortname'] do
    deploy_to deploy_dir(application)
    user node['deployer']['user'] || 'root'
    group www_group

    scm.out.each do |scm_key, scm_value|
      send(scm_key, scm_value)
    end
  end

  scm.after_deploy(self)
end

# every_enabled_application do |application, deploy|
# deploy application['shortname'] do
# deploy_to deploy_dir
# environment application['environment'] || {}
# group www_group
# migrate false
# repository application['app_source']['url']
# rollback_on_error true
# user node['deployer']['user']
# end
# end

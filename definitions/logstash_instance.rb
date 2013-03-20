define :logstash_instance,
       :java_opts => nil do
  params[:java_opts] ||=
    node['logstash_stack'][params[:name]]['java_opts'] ||
    node['logstash_stack']['default']['java_opts']

  include_recipe 'logstash-stack::_common'

  directory "/srv/logstash/#{params[:name]}.conf.d" do
    owner 'root'
    group 'logstash'
    mode 0750
  end

  runit_service "logstash-#{params[:name]}" do
    options params
    run_template_name 'logstash-instance'
    cookbook 'logstash-stack'
    default_logger true
  end
end

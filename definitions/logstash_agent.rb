define :logstash_agent,
       :java_opts => nil do
  params[:java_opts] ||=
    node['logstash'][params[:name]]['java_opts'] ||
    node['logstash']['default']['java_opts']

  include_recipe 'logstash-stack::_common'

  template "/srv/logstash/#{params[:name]}.conf" do
    source 'logstash-agent.conf.erb'
    cookbook 'logstash-stack'
    variables agent: params[:name],
              params: params
    owner 'root'
    group 'logstash'
    mode 0640
    notifies :restart, "runit_service[logstash-#{params[:name]}]"
  end

  runit_service "logstash-#{params[:name]}" do
    options params
    run_template_name 'logstash-agent'
    cookbook 'logstash-stack'
    default_logger true
  end
end

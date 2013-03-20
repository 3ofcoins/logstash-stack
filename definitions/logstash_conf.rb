define :logstash_conf,
       :instance => 'default',
       :source => nil,
       :variables => {} do
  params[:source] ||= "logstash-#{params[:instance]}-#{params[:name]}.conf.erb"
  template "/srv/logstash/#{params[:instance]}.conf.d/#{params[:name]}.conf" do
    source params[:source]
    owner 'root'
    group 'logstash'
    mode '0640'
    variables params[:variables]
    notifies :restart, "runit_service[logstash-#{params[:instance]}]"
  end
end

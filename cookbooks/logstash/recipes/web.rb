include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'

include_recipe 'logstash-stack::_common'

elasticsearch_ip = tagged?('logstash-elasticsearch') ? '127.0.0.1' :
  search(:node,
    "tags:logstash-elasticsearch AND chef_environment:#{node.chef_environment}"
  ).first['ipaddress']

runit_service 'logstash-web' do
  default_logger true
  options :elasticsearch => elasticsearch_ip
end

template "#{node['apache']['dir']}/sites-available/logstash.conf" do
  source 'apache2.conf.erb'
  mode '0644'
  notifies :reload, 'service[apache2]'
end
apache_site 'logstash.conf'

include_recipe 'apache2'
include_recipe 'apache2::mod_proxy'
include_recipe 'apache2::mod_proxy_http'

include_recipe 'logstash-stack::_common'

runit_service 'logstash-web' do
  default_logger true
end

template "#{node['apache']['dir']}/sites-available/logstash.conf" do
  source 'apache2.conf.erb'
  mode '0644'
  notifies :reload, 'service[apache2]'
end
apache_site 'logstash.conf'

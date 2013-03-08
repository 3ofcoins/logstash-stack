include_recipe 'logstash-stack::_common'

elasticsearch_ip = tagged?('logstash-elasticsearch') ? '127.0.0.1' :
  search(:node,
    "tags:logstash-elasticsearch AND chef_environment:#{node.chef_environment}"
  ).first['ipaddress']

redis_ip = es_ip = tagged?('logstash-redis') ? '127.0.0.1' :
  search(:node,
    "tags:logstash-redis AND chef_environment:#{node.chef_environment}"
  ).first['ipaddress']

template '/srv/logstash/indexer.conf' do
  owner 'root'
  group 'logstash'
  mode 0640
  variables :elasticsearch => elasticsearch_ip, :redis => redis_ip
  notifies :restart, 'runit_service[logstash-indexer]'
end

runit_service 'logstash-indexer' do
  default_logger true
end

include_recipe 'logstash-stack::_common'

elasticsearch_ip = tagged?('logstash-elasticsearch') ? '127.0.0.1' :
  search(:node,
    "tags:logstash-elasticsearch AND chef_environment:#{node.chef_environment}"
  ).first['ipaddress']

redis_ip = es_ip = tagged?('logstash-redis') ? '127.0.0.1' :
  search(:node,
    "tags:logstash-redis AND chef_environment:#{node.chef_environment}"
  ).first['ipaddress']

logstash_instance 'indexer'

logstash_conf '99-default' do
  instance 'indexer'
  source 'indexer.conf.erb'
  variables :elasticsearch => elasticsearch_ip, :redis => redis_ip
end

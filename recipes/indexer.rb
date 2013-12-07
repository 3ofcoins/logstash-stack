include_recipe 'logstash-stack::_common'

unless tagged?('logstash-elasticsearch')
  node.set['logstash']['indexer']['output']['50-elasticsearch']['variables']['host'] =
    search(:node,
    "tags:logstash-elasticsearch AND chef_environment:#{node.chef_environment}"
    ).first['ipaddress']
end

unless tagged?('logstash-redis')
  node.set['logstash']['indexer']['input']['50-redis']['variables']['host'] =
    search(:node,
    "tags:logstash-elasticsearch AND chef_environment:#{node.chef_environment}"
    ).first['ipaddress']
end

execute 'generate lumberjack key' do
  command "openssl req -x509 -newkey rsa:2048 -keyout /srv/logstash/indexer-lumberjack.key -out /srv/logstash/indexer-lumberjack.pub -nodes -days 3650 -subj /CN=#{node['fqdn']}"
  creates '/srv/logstash/indexer-lumberjack.key'
  only_if { node['logstash']['indexer']['input']['50-lumberjack'] }
  user 'root'
  group 'logstash'
  umask '0027'
end

ruby_block 'save lumberjack key' do
  block do
    node.set['logstash_stack']['lumberjack']['public_key'] = File.read('/srv/logstash/indexer-lumberjack.pub')
  end
  only_if { node['logstash']['indexer']['input']['50-lumberjack'] }
end

logstash_agent 'indexer'

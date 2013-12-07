default['logstash_stack']['elasticsearch']['config']['cluster.name'] = 'logstash'
default['logstash_stack']['elasticsearch']['config']['node.name'] = name
default['logstash_stack']['elasticsearch']['config']['node.data'] = true

default['logstash_stack']['redis']['use_distribution_packages'] = false

default['logstash_stack']['kibana3']['version'] = '3.0.0milestone4'
default['logstash_stack']['kibana3']['url'] = "https://download.elasticsearch.org/kibana/kibana/kibana-#{node['logstash_stack']['kibana3']['version']}.tar.gz"
default['logstash_stack']['kibana3']['checksum'] = '3ebaac69439aa1925c7918e008978b8424840f3bd3910379d4f2bcf5fdfd2118'
default['logstash_stack']['kibana3']['elasticsearch'] = 'http://127.0.0.1:9200/'
default['logstash_stack']['kibana3']['domain'] = fqdn
default['logstash_stack']['kibana3']['apache2_custom'] = nil

default['logstash']['default']['java_opts'] = '-server -Djava.awt.headless=true -Xmx512M -Xms128M'

default['logstash']['indexer']['input']['50-redis']['template'] = 'logstash-input-redis.conf.erb'
default['logstash']['indexer']['input']['50-redis']['cookbook'] = 'logstash-stack'
default['logstash']['indexer']['input']['50-redis']['variables']['host'] = '127.0.0.1'

default['logstash']['indexer']['input']['50-lumberjack']['template'] = 'logstash-input-lumberjack.conf.erb'
default['logstash']['indexer']['input']['50-lumberjack']['cookbook'] = 'logstash-stack'
default['logstash']['indexer']['input']['50-lumberjack']['variables']['port'] = 5043

default['logstash']['indexer']['input']['50-syslog']['template'] = 'logstash-input-syslog.conf.erb'
default['logstash']['indexer']['input']['50-syslog']['cookbook'] = 'logstash-stack'
default['logstash']['indexer']['input']['50-syslog']['variables']['port'] = 4514

default['logstash']['indexer']['filter']['50-syslog']['template'] = 'logstash-filter-syslog.conf.erb'
default['logstash']['indexer']['filter']['50-syslog']['cookbook'] = 'logstash-stack'

default['logstash']['indexer']['output']['50-elasticsearch']['template'] = 'logstash-output-elasticsearch.conf.erb'
default['logstash']['indexer']['output']['50-elasticsearch']['cookbook'] = 'logstash-stack'
default['logstash']['indexer']['output']['50-elasticsearch']['variables']['host'] = '127.0.0.1'

default['logstash']['shipper']['java_opts'] = '-server -Djava.awt.headless=true -Xmx32M -Xms4M'
default['logstash']['shipper']['rsyslog'] = true
default['logstash']['shipper']['lumberjack'] = {}

default['logstash']['shipper']['output']['50-lumberjack']['template'] = 'logstash-output-lumberjack.conf.erb'
default['logstash']['shipper']['output']['50-lumberjack']['cookbook'] = 'logstash-stack'


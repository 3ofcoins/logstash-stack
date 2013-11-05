default['logstash_stack']['elasticsearch']['config']['cluster.name'] = 'logstash'
default['logstash_stack']['elasticsearch']['config']['node.name'] = name
default['logstash_stack']['elasticsearch']['config']['node.data'] = true

default['logstash_stack']['redis']['use_distribution_packages'] = false

default['logstash_stack']['default']['java_opts'] = '-server -Djava.awt.headless=true -Xmx512M -Xms128M'

default['logstash_stack']['indexer'] = {}

default['logstash_stack']['shipper']['java_opts'] = '-server -Djava.awt.headless=true -Xmx32M -Xms4M'

default['logstash_stack']['kibana3']['version'] = '3.0.0milestone4'
default['logstash_stack']['kibana3']['url'] = "https://download.elasticsearch.org/kibana/kibana/kibana-#{node['kibana']['kibana3_version']}.tar.gz"
default['logstash_stack']['kibana3']['checksum'] = '3ebaac69439aa1925c7918e008978b8424840f3bd3910379d4f2bcf5fdfd2118'
default['logstash_stack']['kibana3']['elasticsearch'] = 'http://127.0.0.1:9002/'


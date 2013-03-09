default['logstash_stack']['elasticsearch']['config']['cluster.name'] = 'logstash'
default['logstash_stack']['elasticsearch']['config']['node.name'] = name
default['logstash_stack']['elasticsearch']['config']['node.data'] = true

default['logstash_stack']['redis']['use_distribution_packages'] = false

default['logstash_stack']['indexer']['java_opts'] = '-server -Djava.awt.headless=true -Xmx512M -Xms128M'

default['logstash_stack']['web']['java_opts'] = '-server -Djava.awt.headless=true -Xmx256M -Xms64M'
default['logstash_stack']['web']['domain'] = (fqdn rescue nil)


default['logstash_stack']['shipper']['java_opts'] = '-server -Djava.awt.headless=true -Xmx32M -Xms4M'

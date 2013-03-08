default['logstash_stack']['elasticsearch']['config']['cluster.name'] = 'logstash'
default['logstash_stack']['elasticsearch']['config']['node.name'] = name
default['logstash_stack']['elasticsearch']['config']['node.data'] = true

default['logstash_stack']['redis']['use_distribution_packages'] = false

default['logstash_stack']['indexer'] = {}
default['logstash_stack']['shipper'] = {}
default['logstash_stack']['web']['domain'] = (fqdn rescue nil)

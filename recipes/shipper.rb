chef_gem 'chef-helpers'
require 'chef-helpers'

indexer = tagged?('logstash-indexer') ? node : search(:node, 'tags:logstash-indexer').first

raise "Can't find a Logstash indexer" unless indexer

if node['logstash']['shipper']['input'] && !node['logstash']['shipper']['input'].empty?
  include_recipe 'logstash_stack::_common'

  file '/srv/logstash/shipper-lumberjack.ca.crt' do
    mode 0400
    content indexer['logstash']['indexer']['lumberjack']['public_key']
  end

  node.override['logstash']['shipper']['output']['50-lumberjack']['variables']['host'] = node.ip_for(indexer)
  node.override['logstash']['shipper']['output']['50-lumberjack']['variables']['port'] = indexer['logstash']['indexer']['input']['50-lumberjack']['variables']['port']

  logstash_agent 'shipper' do
    indexer indexer
  end
end

if indexer['logstash']['indexer']['input']['50-syslog'] &&
    indexer['logstash']['indexer']['input']['50-syslog']['variables']['port'] &&
    node['logstash']['shipper']['rsyslog']
  node.override['rsyslog']['server_ip'] = node.ip_for(indexer)
  node.override['rsyslog']['port'] = indexer['logstash']['indexer']['input']['50-syslog']['variables']['port']
  node.override['rsyslog']['protocol'] = 'tcp'
  node.override['rsyslog']['max_message_size'] = '64k'
  node.override['rsyslog']['preserve_fqdn'] = 'on'
  include_recipe 'rsyslog::client'
end

lumberjack_files = Array(node['logstash']['shipper']['lumberjack']).sort.map { |_,v| v if v }.compact
if indexer['logstash']['indexer']['input']['50-lumberjack'] &&
    indexer['logstash']['indexer']['input']['50-lumberjack']['variables']['port'] &&
    !lumberjack_files.empty?
  package 'lumberjack'
  service 'lumberjack'

  file '/etc/lumberjack.ca.crt' do
    mode 0400
    content indexer['logstash']['indexer']['lumberjack']['public_key']
    notifies :restart, 'service[lumberjack]'
  end

  file '/etc/lumberjack.conf' do
    mode 0640
    content JSON.pretty_generate({
        'network' => {
          'servers' => [ "#{node.ip_for(indexer)}:#{indexer['logstash']['indexer']['input']['50-lumberjack']['variables']['port']}" ],
          'ssl ca' => '/etc/lumberjack.ca.crt',
          'timeout' => 15
        },
        'files' => lumberjack_files
      })
    notifies :restart, 'service[lumberjack]'
  end
end

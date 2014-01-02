include_recipe 'java'

if node['logstash_stack']['elasticsearch']['config']['path.data']
  directory node['logstash_stack']['elasticsearch']['config']['path.data'] do
    owner 'elasticsearch'
    group 'elasticsearch'
    mode 0750
  end
end

package 'elasticsearch'
service 'elasticsearch'

file '/etc/elasticsearch/elasticsearch.yml' do
  owner 'root'
  group 'elasticsearch'
  mode '0640'
  content YAML::dump(node['logstash_stack']['elasticsearch']['config'].to_hash)
  notifies :restart, 'service[elasticsearch]'
end

tag 'logstash-elasticsearch'

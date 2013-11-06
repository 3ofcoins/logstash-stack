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

# https://gist.github.com/deverton/2970285
http_request 'elasticsearch::template_logstash' do
  action :put
  url 'http://localhost:9200/_template/template_logstash/'
  message(
    template: "logstash*",
    settings: {
      "index.query.default_field" => "message",
      "index.cache.field.type" => "soft",
      "index.store.compress.stored" => true },
    mappings: {
      _default_: {
        _all: { enabled: false },
        properties: {
          "message" =>    { type: "string", index: "analyzed" },
          "@version" =>   { type: "string", index: "not_analyzed" },
          "@timestamp" => { type: "date", index: "not_analyzed" },
          "type" =>       { type: "string", index: "not_analyzed" }
        }}})
end

tag 'logstash-elasticsearch'

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
    :template => "logstash-*",
    :settings => {
      :number_of_shards => 1,
      :number_of_replicas => 0,
      :index => {
        :query => { :default_field => "@message" },
        :store => { :compress => { :stored => true, :tv => true } }}},
    :mappings => {
      :_default_ => {
        :_all => { :enabled => false },
        :_source => { :compress => true },
        :dynamic_templates => [{
          :string_template => {
              :match => "*",
              :mapping => { :type => "string", :index => "not_analyzed" },
              :match_mapping_type => "string"
            }}],
        :properties => {
          :@fields      => { :type => "object", :dynamic => true, :path => "full" },
          :@message     => { :type => "string", :index => "analyzed" },
          :@source      => { :type => "string", :index => "not_analyzed" },
          :@source_host => { :type => "string", :index => "not_analyzed" },
          :@source_path => { :type => "string", :index => "not_analyzed" },
          :@tags        => { :type => "string", :index => "not_analyzed" },
          :@timestamp   => { :type => "date",   :index => "not_analyzed" },
          :@type        => { :type => "string", :index => "not_analyzed" }
        }}})
end

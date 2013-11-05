ark "kibana" do
  url node['logstash_stack']['kibana3']['url']
  version node['logstash_stack']['kibana3']['version']
  checksum node['logstash_stack']['kibana3']['checksum']
  path '/opt/kibana'
  home_dir '/opt/kibana/current'
end

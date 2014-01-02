include_recipe 'apache2'
include_recipe "apache2::mod_proxy"
include_recipe "apache2::mod_proxy_http"
include_recipe 'apache2::mod_rewrite'
if node['logstash_stack']['kibana3']['ssl_key_path']
  include_recipe 'apache2::mod_ssl'
end

ark "kibana" do
  url node['logstash_stack']['kibana3']['url']
  version node['logstash_stack']['kibana3']['version']
  checksum node['logstash_stack']['kibana3']['checksum']
  prefix_root '/opt/kibana'
  home_dir '/opt/kibana/current'
end

cookbook_file '/opt/kibana/current/app/dashboards/default.json' do
  source 'kibana-default.json'
end

cookbook_file '/opt/kibana/current/config.js' do
  source 'kibana-config.js'
end

web_app 'kibana'

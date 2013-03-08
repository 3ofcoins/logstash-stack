include_recipe "java"
include_recipe "runit"

package "logstash"

group "logstash" do
  system true
end

user "logstash" do
  system true
  group "logstash"
  home "/srv/logstash"
  shell "/bin/false"
end

directory '/srv/logstash'

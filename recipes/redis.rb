unless node['logstash_stack']['redis']['use_distribution_packages']
  case node['platform']
  when 'ubuntu'
    apt_repository "redis" do
      uri "http://ppa.launchpad.net/rwky/redis/ubuntu"
      distribution node['lsb']['codename']
      components %w(main)
      keyserver "keyserver.ubuntu.com"
      key "5862E31D"
      action :add
    end
  else
    Chef::Log.warn("Using distribution packages, don't know unofficial source for #{node['platform']} yet.")
  end
end

package 'redis-server'

tag 'logstash-redis'

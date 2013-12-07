The Logstash Stack
==================

This cookbook includes recipes to set up a Logstash
(http://www.logstash.net) installation.

Requirements
------------

### Packages

This cookbook relies on system packages for the software used. The
packages can be built using a Rake script in the `packages/`
subdirectory:

    $ bundle install
    $ bundle exec rake

These packages should be either preinstalled by another cookbook, or
available in an apt repository.

### Cookbooks

 * apache2
 * apt
 * ark
 * java
 * runit

Attributes
----------

 * `node['logstash_stack']['elasticsearch']['config'][…]` -- `elasticsearch.yml` configuration 
 * `node['logstash_stack']['redis']['use_distribution_packages']` (default: `false`) -- use distribution's `redis-server` package rather than a PPA (meaningful only on Ubuntu)

 * `node['logstash']['default']['java_opts']` (default: `'-server -Djava.awt.headless=true -Xmx512M -Xms128M'`) -- default agent's Java options

 * `node['logstash'][agent_name][…]` -- configuration for a given Logstash intance:
   * `node['logstash'][agent_name][…]['java_opts']` (default: `node['logstash']['default']['java_opts']`) -- Java options for the agent
   * `node['logstash'][agent_name]['input'][…]` -- agent's inputs (see the *Usage* section)
   * `node['logstash'][agent_name]['filter'][…]` -- agent's filters (see the *Usage* section)
   * `node['logstash'][agent_name]['output'][…]` -- agent's outputs (see the *Usage* section)

 * `node['logstash_stack']['kibana3']['domain']` (default: `node.fqdn`) -- domain to serve Kibana at
 * `node['logstash_stack']['kibana3']['apache2_custom']` (default: `nil`) -- custom snippet of Apache config for Kibana (e.g. authentication)
 * `node['logstash_stack']['kibana3']['ssl_key_path']`,
   `node['logstash_stack']['kibana3']['ssl_certificate_path']`,
   `node['logstash_stack']['kibana3']['ssl_certificate_chain_path']` -- if set, Kibana will be served over https
 * `node['logstash_stack']['kibana3']['elasticsearch']` (default: `'http://127.0.0.1:9200/'`) -- URL at which Apache serving Kibana can access Logstash's Elasticsearch

Definitions
-----------

`logstash_agent` -- sets up a Logstash agent with given name

Recipes
-------

### logstash_stack::default

The default use case: sets up Elasticsearch, Redis, `indexer` Logstash
agent, and Kibana frontend.

### logstash_stack::elasticsearch, logstash_stack::redis

These recipes install Elasticsearch for Logstash output, and Redis for
Logstash input.

### logstash_stack::indexer

Installs Logstash agent named `indexer`, configured by default to
take input from Redis, syslog TCP, and Lumberjack, and output to
Elasticsearch.

### logstash_stack::kibana

Installs Kibana 3 served by Apache

### logstash_stack::shipper

Configures machine as a Logstash shipper that ships to the indexer
instance (one that runs `logstash_stack::indexer` recipe).

If the indexer is configured with syslog input, and
`node['logstash']['shipper']['rsyslog']` is true (default), then
rsyslog is configured to ship all events to the Logstash indexer.

If the indexer is configured with lumberjack input, and there are
entries configured in `node['logstash']['shipper']['lumberjack']`,
then Lumberjack is installed and configured to send events to the
indexer.

Finally, if any input is configured in
`node['logstash']['shipper']['input']`, then a Logstash agent named
`shipper` is configured to ship events to the indexer using the
`lumberjack` protocol.

The templates used in shipper's config can use `@params[:indexer]` to
access indexer's Node instance.

Logstash Agent Configuration
-------------------------------

The main piece of configuration is configuring the Logstash agents;
either manually by calling out to the `logstash_agent` definition,
or by using the `logstash_stack::indexer` or `logstash_stack` recipe
which call `logstash_agent "indexer"`. The agent definition
usually takes just a name, and its config file is generated from node's
attributes.

The `node['logstash'][agent_name]['input'][…]`,
`node['logstash'][agent_name]['filter'][…]`, and
`node['logstash'][agent_name]['output'][…]` are dictionaries that
will be used to compile agent configuration's input, filter, and
output sections. A section is written in a following way:

1. Take all entries, order them by their keys
2. If the value is `nil` or `false`, skip the entry - this can be used
   to skip a section that's enabled by default
3. If the value is a string, paste it verbatim
4. If the value is a hash, render it as a subtemplate; the `template`
   will be template name, and rest of the hash will be passed as a
   subtemplate's options. Additionally, subtemplate will get variables
   `@agent` with the agent name, and `@params` with parameters
   of the `logstash_agent` call.

The subtemplate setup may not be clear; here are examples from the
default `indexer` agent's configuration:

```ruby
default['logstash']['indexer']['input']['50-redis']['template'] = 'logstash-input-redis.conf.erb'
default['logstash']['indexer']['input']['50-redis']['cookbook'] = 'logstash-stack'
default['logstash']['indexer']['input']['50-redis']['variables']['host'] = '127.0.0.1'
```

The corresponding `logstash-input-redis.conf.erb` template look like this:

```
redis {
  host => "<%= @host %>"
  type => "redis-input"
  data_type => "list"
  key => "logstash"
  codec => json
}

License and Authors
-------------------
Authors: Maciej Pasternacki <maciej@3ofcoins.net>

License: MIT (see the LICENSE file for details)

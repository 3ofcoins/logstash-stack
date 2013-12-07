CHANGELOG for logstash
======================

This file is used to list changes made in each version of logstash.

0.4.0
-----

* Renamed `logstash_instance` to `logstash_agent`
* Use dictionary-based single-file instance configuration rather than including
  directory; single file configuration is more
  predictable. `logstash_config` definition has been obviously
  deleted.
* Updated documentation
* Added separate LICENSE and CONTRIBUTING.md files

0.3.0
-----

* Bump to logstash 1.2.2 / elasticsearch 0.90.3
* Bring back packages/ dir
* Kibana 3 proxied by Apache

0.2.0
-----

* Use Kibana rather than logstash-web
* Move package Rakefile to root

0.1.0
-----

* Initial release of logstash

- - -
Check the [Markdown Syntax Guide](http://daringfireball.net/projects/markdown/syntax) for help with Markdown.

The [Github Flavored Markdown page](http://github.github.com/github-flavored-markdown/) describes the differences between markdown on github and standard markdown.

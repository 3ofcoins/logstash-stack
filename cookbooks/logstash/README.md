logstash-stack Cookbook
=======================

This cookbook includes recipes to set up a Logstash
(http://www.logstash.net) installation.

Requirements
------------

### Packages

This cookbook relies on system packages for the software used. The
packages can be built using a Rake script in the `packages/`
subdirectory:

    $ bundle install
    $ cd packages/
    $ bundle exec rake

These packages should be either preinstalled by another cookbook, or
available in an apt repository.

Attributes
----------
TODO: List you cookbook attributes here.

e.g.
#### logstash::default
<table>
  <tr>
    <th>Key</th>
    <th>Type</th>
    <th>Description</th>
    <th>Default</th>
  </tr>
  <tr>
    <td><tt>['logstash']['bacon']</tt></td>
    <td>Boolean</td>
    <td>whether to include bacon</td>
    <td><tt>true</tt></td>
  </tr>
</table>

Usage
-----
#### logstash::default
TODO: Write usage instructions for each cookbook.

e.g.
Just include `logstash` in your node's `run_list`:

```json
{
  "name":"my_node",
  "run_list": [
    "recipe[logstash]"
  ]
}
```

Contributing
------------
TODO: (optional) If this is a public cookbook, detail the process for contributing. If this is a private cookbook, remove this section.

e.g.
1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

License and Authors
-------------------
Authors: TODO: List authors

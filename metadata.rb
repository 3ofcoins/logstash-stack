name             'logstash-stack'
maintainer       'Maciej Pasternacki'
maintainer_email 'maciej@pasternacki.net'
license          'MIT'
description      'Installs/Configures logstash'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.2.0'

supports 'debian'
supports 'ubuntu'

depends 'apache2'
depends 'apt'
depends 'java'
depends 'kibana'
depends 'runit'

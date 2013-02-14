jolokia_templates
=================

JSON JMX templates for jolokia -> ganglia integration.

These templates end up getting consumed by node-jolosrv and finally by ganglia.

Usage
-----

### Templates

### Mappings

  The services.json mappings is to represent our `service => template` lookup

### Flow Diagram

    jolokia_templates --> git pull --> node-jolosrv --> node-gmond --> gmetric

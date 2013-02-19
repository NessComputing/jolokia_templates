jolokia_templates
=================

JSON JMX templates for jolokia -> ganglia integration.

These templates end up getting consumed by node-jolosrv and finally by ganglia.

Usage
-----

### Templates

The templates are a mapping of JMX -> ganglia graphs, there are some relatively
unfortunate things about the way JMX composite objects work, but we have a way
to address them.

Every JMX object effectively acts like k/v (outside of functions).

I picture the heirarchy like the following

    mbean -> types/names (if any) -> attribute or composite

Composite children are referenced by the pipe character `|`.

Each attribute, or composite attribute needs a graph specified,
which tells ganglia how it is supposed to interpret the information.

```javascript
{
  "name": "name_of_my_template",
  "mappings": [
    {
      "mbean": "java.lang:name=ConcurrentMarkSweep,type=GarbageCollector",
      "attributes": [
        { "name": "CollectionCount",
          "graph": {
            "name": "ConcurrentMarkSweep_Collection_Count",
            "description": "Concurrent MarkSweep Collection Count",
            "units": "objects",
            "type": "uint32",
            "slope": "positive"
          }
        },

        { "name": "LastGcInfo",
          "composites": [

            { "name": "memoryUsageBeforeGc|Code Cache|init",
              "graph": {
                "name": "MemoryUsage_Before_GC_Code_Cache_Init",
                "description": "Code Cache (Init) Memory Usage Before GC",
                "units": "bytes",
                "type": "int32"
              }
            }

          ]
        }

      ]
    }
  ]
}
```

#### Ineritance

Templates can inherit a parent by just adding the inherits key:

```javascript
{
  "name": "child_of_base",
  "inerhits": "base",
  "mappings": [

  ...
}
```

### Mappings

The services.json mappings is to represent our `service => template` lookup

### Flow of info

    jolokia_templates --> git pull --> node-jolosrv --> node-gmond --> gmetric

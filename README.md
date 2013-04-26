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
  "inherits": "base",
  "mappings": [

  ...
}
```

### Mappings

The services.json mappings is to represent our `service => template` lookup

### Flow of info

    jolokia_templates --> git pull --> node-jolosrv --> node-gmond --> gmetric

## Adding services

There's an excellent tool provided by jolokia_client called `jmx4node` that allows us to query jolokia.

We have a local fork at `git@github.com:NessComputing/jolokia-client.git`.

To install it `jmx4node`, we need to have node installed.

```bash
brew install node
npm install -g jolokia_client
```

And verify that your profile has node binaries in the $PATH

`export PATH=/usr/local/share/npm/bin:$PATH`

### Verifying service info against galaxy

We have a tool to show http ports on galaxy services called `galaxy-info`.

If you would like a listing of services you can run `/usr/local/bin/galaxy-info list` and it will show the service/port entries.

Finally, to get a list of attributes for a jmx entry, you can run `jxm4node <url> list  [mbean]`.

ex: `jmx4node http://10.20.30.40:8080/jolokia/ list JMImplementation`

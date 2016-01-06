# XML parser plugin for Embulk

Parser plugin for [Embulk](https://github.com/embulk/embulk).

Embulk parser plugin for XML with XPath support ? Edit

## Overview

* **Plugin type**: parser
* **Load all or nothing**: yes
* **Resume supported**: no


## Configuration

```yaml
parser:
  type: xpath
  root: /rdf:RDF
  schema:
    - {name: //si:title[1], type: string}
    - {name: //si:author, type: string}
  namespaces:
    "rdf" : "http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    "si" : "http://www.w3schools.com/rdf/"
```

- **type**: specify this plugin as `xml`
- **root**: root property to start fetching each entries, specify in *path/to/node* style, required
- **schema**: specify the attribute of table and data type, required
- **namespaces**: xml namespaces

Then you can fetch entries from the following xml:

```xml
<?xml version="1.0"?>
<rdf:RDF
  xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
  xmlns:si="http://www.w3schools.com/rdf/">
  <rdf:Description rdf:about="http://www.w3schools.com">
    <si:title>W3Schools</si:title>
    <si:author>Jan Egil Refsnes</si:author>
  </rdf:Description>
</rdf:RDF>
```

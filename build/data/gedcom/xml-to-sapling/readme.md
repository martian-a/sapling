# Running from the command-line

## To convert XML to Sapling

./calabash -d [path to exported gedcom text file] [path to build/data/gedcom/xml-to-sapling/xml2sapling.xpl]

### Subpipelines

#### insert-prov-metadata

Inserts basic metadata about this process, intended to support tracing the data lineage of the result of this pipeline, including:
* the name of the pipeline applying this transformation
* which user started the transformation
* when the transformation started and ended
* a URI identifying the source document(s) fed into the transformation

#### uuid

Replaces @id values, prefixed with 'REPLACE-', with a version 4 UUID.

#### add-id-to-extracts

Generate an @id value for each source extract.

#### debug

Save the current result in a temporary file.

#### validate-with-schematron (disabled)

Use Schematron to check the validity of an XML document.
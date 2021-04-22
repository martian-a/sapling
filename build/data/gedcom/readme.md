# Running from the command-line

## To convert GEDCOM text file to RDF

./calabash -d [path to exported gedcom text file] [path to build/data/gedcom/text2rdf.xpl]

### Subpipelines

#### text-to-xml

Parse a GEDCOM text file and serialise it as XML.

#### xml-to-sapling

Parse the output of the text-to-xml pipeline and generate a valid Sapling XML file from it.

#### sapling-to-rdf

Parse a valid Sapling XML file and serialise it as RDF triples.

# Running from the command-line

## To convert GEDCOM text file to Sapling XML

./calabash -d [path to exported gedcom text file] [path to build/data/gedcom/text2sapling.xpl]

### Subpipelines

#### text-to-xml

Parse a GEDCOM text file and serialise it as XML.

#### gedcom-xml-to-sapling

Parse the output of the text-to-xml pipeline and generate a valid Sapling XML file from it.

#### sapling-consistency-checks

Parse the output of the gedcom-xml-to-sapling pipeline and generate files intended to aid human data quality checks.

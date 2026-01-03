# Running from the command-line

## To convert GEDCOM text file to XML

./calabash -d [path to exported gedcom text file] [path to build/data/gedcom/text-to-xml/text2xml.xpl]

### Subpipelines

#### debug

Save the current result in a temporary file.

#### validate-with-schematron

Use Schematron to check the validity of an XML document.

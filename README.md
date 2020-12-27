sapling
=======

An application for offline editing and review of a family history website, plus a pipeline that generates a static version of the website for publishing online.

## Core components

+ app - application code and assets.
+ build - pipeline for generating data sets and views from the project data.
+ dist - where the results of a build pipeline will appear.
+ documentation - if you're lucky...
+ lib - information about dependencies
+ resources - random useful things that are used by the project, such as ontologies and raw image files.
+ schemas - to help with maintaining data quality.
+ static - generic static assets that are used by the app.
+ test - test cases and data

## Functionality

### Import data from Ancestry

+ Place exported Ancestry data file in geneaology-data-global/import/ancestry/
+ Name the Ancestry data file "*.ged.txt"
+ Run build/data/gedcom/text2rdf.xpl (see build/data/gedcom/readme.md) 
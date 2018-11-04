# Pre-processing Steps

## Sequence

1. Merge data sources
2. De-reference serials
3. Store result
4. Validate result
5. Sort entities
6. Filter out tentative events (if scope != 'private')
7. Split source extracts (if scope != 'private')
8. Filter data to core people (if scope != 'private')
9. Exclude people not explict publish (if scope != 'private')
10. Filter by core entities
11. Sort entities
12. Insert married names 
13. Insert references
14. Insert character counts

## Step Summaries

### Merge Data Sources
Stylesheet: merge_data_sources.xsl

* Resolves XInclude statements, pulling all XIncluded data into a single document.

### De-reference Serials
Stylesheet: dereference_serials.xsl

* Matches all references to a serial publication and replaces the reference with a copy of the actual data from the referenced serial definition.
* Suppresses serial definitions (as they are no longer needed).

### Store Result

* Store the current state of the data in a temporary file, in the distribution directory.

### Validate Result

* Check that, in its current state, the data is:
     * structured as expected
     * meets all other constraints expressed via an associated schema

### Sort Entities
Stylesheet: sort_entities.xsl

* Sort all entities by their ID number, ascending.
* Does not sort extracts, which have an ID (but are not an entity); these should remain in document order.

### Filter Out Tentative Events
Stylesheet: filter_out_tentative_events.xsl

*This step is NOT applied if scope = 'private'.*

* Suppress events that are marked as being tentative (@temp:status = 'tentative')

*TODO: When sufficient events have sources... change this step to exclude all events that don't yet have a source.*

### Split Source Extracts
Stylesheet: split_source_extracts.xsl

*This step is NOT applied if scope = 'private'.*

* If a source contains more than one extract, create duplicates of the source, each copy containing only one of the extracts.

### Filter Data to Core People
Stylesheet: filter_data_to_core_people.xsl

*This step is NOT applied if scope = 'private'.*

* Creates network graphs from the data, where:
     * nodes are people
     * events provide the edges
* Divides people into two groups:
     * include (core): people in the largest network
     * exclude: 
    	 * people who aren't in the largest network
         * all other entities  

### Exclude People Not Explict Publish
Stylesheet: exclude_people_not_explicit_publish.xsl

*This step is NOT applied if scope = 'private'.*

* Suppress all person elements EXCEPT those with @publish = 'true'

### Filter by Core Entities
XProc Pipeline: filter_by_core_entities.xpl

*This step is NOT applied if scope = 'private'.*

* While there is still excluded data that is referenced from within the core (included) data, keep applying Filter by Core Entities.
* When there is no exluded data that is referenced from within the core (included) data, Filter to Core Entities. 

#### Filter by Core Entities
Stylesheet: filter_by_core_entities.xsl

* Re-include data into core if it is referenced from within data that is already in core.

#### Filter to Core Entities
Stylesheet: filter_to_core_entities.xsl

* Suppress data that remains in the excluded group.

### Join Source Extracts
Stylesheet: join_source_extracts.xsl

*This step is NOT applied if scope = 'private'.*

* Merge all remaining sources (duplicates were created in the split source extracts step) so that extracts are joined back together under a single source entry.

### Insert Married Names
Stylesheet: insert_married_names.xsl

* Modify person record to include personas for married names.

### Insert References
Stylesheet: insert_references.xsl

* Modify each source to include a bibliographic reference.

### Insert Character Counts
Stylesheet: insert_character_counts.xsl

* Modify the body of each source (or source extract) to include a classification that indicates how long it is (long, medium, short, micro)
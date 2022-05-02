<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="filter-to-direct-ancestors"
	type="tcy:filter-to-direct-ancestors"
	version="3.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Add back in currently excluded entities that are referenced by core entities.</d:p>
		</d:desc>
	</p:documentation>
	
	<p:import href="add_parents.xpl" /> 
	<p:import href="../../for-website/pre-process/re-include-referenced-entities/re_include_referenced_entities.xpl" />
	
	
	<p:input port="source" primary="true" />
	
	<p:output port="result" sequence="false" />
	
	<p:option name="anchor-person-id" required="true" />
	
	<!-- Move all entities into an exclude set except the anchor person, who will initially be the only entity in the include set. --> 
	<p:xslt message="Pedigree Anchor Person ID: {$anchor-person-id}"> 
		<p:with-input port="stylesheet">
			<p:document href="filter_data_to_anchor_person.xsl" />
		</p:with-input>
		<p:with-option name="parameters" select="map{'anchor-person-id': $anchor-person-id}" />
	</p:xslt>				
	
	<tcy:add-parents />
			
	<tcy:re-include-referenced-entities />
	
</p:declare-step>
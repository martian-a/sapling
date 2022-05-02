<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="filter-to-largest-network"
	type="tcy:filter-to-largest-network"
	version="3.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Reduce the data in the file to just those entities that are in or directly associated with the largest network of people in the file.</d:p>
			<d:list>
				<d:li>Organise all people in the file into networks, using their birth/christening events.</d:li>
				<d:li>Work out which network is largest.</d:li>
				<d:li>Find all the other entities associated with largest network</d:li>
				<d:li>Delete all entities that aren't in or directly associated with the largest network of people.</d:li>
			</d:list>
		</d:desc>
	</p:documentation>
	
	<p:import href="../re-include-referenced-entities/re_include_referenced_entities.xpl" />
	
	
	<p:input port="source" primary="true" />
	
	<p:output port="result" sequence="false" />
	
	
	<!-- Find the largest network of people, put them into an "include" collection 
		 and put all other entities (people, places, locations, sources, etc.) into 
		 an "exclude" collection. --> 
	<p:xslt> 
		<p:with-input port="stylesheet">
			<p:document href="filter_data_to_core_people.xsl" />
		</p:with-input>
	</p:xslt>				
	
	<!-- Find all entities in the "exclude" collection that are related to those in 
		 the "include" collection and move those into the "include" collection. -->
	<tcy:re-include-referenced-entities />
	
</p:declare-step>
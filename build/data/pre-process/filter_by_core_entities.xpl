<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="filter-by-core-entities"
	type="tcy:filter-by-core-entities"
	version="2.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Add back in currently excluded entities that are referenced by core entities.</d:p>
		</d:desc>
	</p:documentation>
	
	<p:input port="source" primary="true" />
	
	<p:output port="result" />
	
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>		
	
	<p:choose>
		
		<p:xpath-context>
			<p:pipe port="source" step="filter-by-core-entities" />
		</p:xpath-context>
		
		<p:when test="count(/app/data/exclude/*/*[concat(@id, body-matter/extract/@id) = /app/data/include/descendant::*/concat(@ref, @extract)]) &gt; 0">
	
			<p:xslt> 
				<p:input port="source">
					<p:pipe port="source" step="filter-by-core-entities" />
				</p:input>
				<p:input port="stylesheet">
					<p:document href="filter_by_core_entities.xsl" />
				</p:input>
				<p:input port="parameters">
					<p:empty />
				</p:input>
			</p:xslt>
			
			<tcy:filter-by-core-entities />
					
		</p:when>
		
		<p:otherwise>
			
			<p:xslt>
				<p:input port="source">
					<p:pipe port="source" step="filter-by-core-entities" />
				</p:input>
				<p:input port="stylesheet">
					<p:document href="filter_data_to_core_entities.xsl" />
				</p:input>
				<p:input port="parameters">
					<p:empty />
				</p:input>
			</p:xslt>
			
		</p:otherwise>
	</p:choose>
	
</p:declare-step>
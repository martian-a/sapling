<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="pre-process-data"
	type="tcy:pre-process-data"
	version="2.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Prepares source data for build process.</d:p>
		</d:desc>
	</p:documentation>
	
	<p:input port="source" />
	
	<p:output port="result" />
	
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
			
	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="merge_data_sources.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	
	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="sort_entities.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	
	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="filter_data_to_core_people.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	
	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="exclude_people_not_explicit_publish.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	

	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="filter_events_by_core_people.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="filter_organisations_by_core_people.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="filter_locations_by_core_people.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="filter_people_by_core_people.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
		
</p:declare-step>
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
	<p:import href="filter_by_core_entities.xpl" />
	
	<p:option name="target" required="true" />
			
	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="merge_data_sources.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	
	<p:xslt name="dereference-serials"> 
		<p:input port="stylesheet">
			<p:document href="dereference_serials.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	
	<p:validate-with-relax-ng assert-valid="false">
		<p:input port="schema">
			<p:data href="../../../../sapling/schemas/sapling/sapling.rnc" content-type="text/plain"/>
		</p:input>
	</p:validate-with-relax-ng>
	
	
	<p:store encoding="UTF-8" byte-order-mark="false" indent="true">
		<p:with-option name="href" select="$target" />
	</p:store>

	
	<p:xslt> 
		<p:input port="source">
			<p:pipe port="result" step="dereference-serials" />
		</p:input>
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
	
	
	<p:xslt name="safe"> 
		<p:input port="stylesheet">
			<p:document href="exclude_people_not_explicit_publish.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	
	<tcy:filter-by-core-entities>
		<p:input port="source">
			<p:pipe port="result" step="safe" />
		</p:input>
	</tcy:filter-by-core-entities>
	
	
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
			<p:document href="insert_references.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
	
	<p:xslt> 
		<p:input port="stylesheet">
			<p:document href="insert_character_counts.xsl" />
		</p:input>
		<p:input port="parameters">
			<p:empty />
		</p:input>
	</p:xslt>
			
</p:declare-step>
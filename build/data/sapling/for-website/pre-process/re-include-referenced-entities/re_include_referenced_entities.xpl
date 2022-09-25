<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="re-include-referenced-entities"
	type="tcy:re-include-referenced-entities"
	version="3.0">
	
	<p:import href="../../../../../utils/provenance/insert-prov-metadata.xpl" />
	<p:import href="../../../../../utils/debug.xpl" />
	
	<p:documentation>
		<d:desc>
			<d:p>Add back in currently excluded entities that are referenced by core entities.</d:p>
		</d:desc>
	</p:documentation>
	
	<p:input port="source" primary="true" sequence="false" />
	
	<p:output port="result" sequence="true" />	
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="re_include_referenced_entities.xsl" />
		</p:with-input>
	</p:xslt>	
	
	<tcy:debug file-extension="pre-clean-up.xml"  />   
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="clean_up.xsl" />
		</p:with-input>
	</p:xslt>	
	
	<tcy:debug file-extension="post-clean-up.xml"  />   
	
</p:declare-step>
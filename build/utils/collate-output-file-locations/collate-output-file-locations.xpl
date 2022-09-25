<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step" 
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	name="collate-output-file-locations"
	type="tcy:collate-output-file-locations"
	version="3.0">
	
	<p:input port="source" primary="true" sequence="true" />
	
	<p:output port="result" sequence="false" />
	
	<p:wrap-sequence wrapper="output-file-locations" />
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="format_output_uris_list.xsl" />
		</p:with-input>
	</p:xslt>
		
</p:declare-step>
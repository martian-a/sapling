<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="network-to-d3"
    type="tcy:network-to-d3"
    version="3.0">
    
	<p:import href="../../../utils/provenance/insert-prov-metadata.xpl" />
	<p:import href="../../../utils/debug.xpl" />
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="false" content-types="text/plain" />
    
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />

	<p:variable name="pipeline-start-time" select="current-dateTime()" />

	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="network2d3.xsl" />
		</p:with-input>		
	</p:xslt>   		
	
</p:declare-step>
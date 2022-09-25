<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="sapling-to-family-tree-network"
    type="tcy:sapling-to-family-tree-network"
    version="3.0">
    
	<p:import href="../../../../utils/provenance/insert-prov-metadata.xpl" />
	<p:import href="../../../../utils/debug.xpl" />
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="true" />
    
    <p:option name="with-node-for-parent-group" select="'true'" />
	<p:option name="path-to-output-folder" select="'../../output/'" />
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />

	<p:variable name="pipeline-start-time" select="current-dateTime()" />
	<p:variable name="stylesheet" select="concat(if (xs:boolean($with-node-for-parent-group) = true()) then 'with' else 'without', '_node_for_parent_group.xsl')" />

	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="{$stylesheet}" />
		</p:with-input>		
	</p:xslt>   	
	
	<p:group name="result-provenance-metadata">
				
		<tcy:insert-prov-metadata name="prov-metadata">
			<p:with-option name="generated-by-user" select="$generated-by-user" />
			<p:with-option name="generated-by-pipeline" select="p:urify(resolve-uri(''))" />
			<p:with-option name="pipeline-start-time" select="$pipeline-start-time" />
			<p:with-option name="pipeline-end-time" select="current-dateTime()" />
			<p:with-option name="source-uri" select="p:urify(document-uri(/))" />
		</tcy:insert-prov-metadata>  
		
	</p:group>
	
</p:declare-step>
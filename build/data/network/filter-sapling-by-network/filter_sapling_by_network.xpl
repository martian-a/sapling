<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="filter-sapling-by-network"
    type="tcy:filter-sapling-by-network"
    version="3.0">
    
	<p:import href="../../sapling/for-website/pre-process/re-include-referenced-entities/re_include_referenced_entities.xpl" />
	<p:import href="../../../utils/provenance/insert-prov-metadata.xpl" />
	<p:import href="../../../utils/debug.xpl" />
    
    <p:input port="source" sequence="false" primary="true" />
	<p:input port="network" sequence="false" />    
    <p:output port="result" sequence="true" />
    
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />

	<p:variable name="pipeline-start-time" select="current-dateTime()" />
	
	<p:variable name="core-people-ids" select="/network/nodes/node/@id">
		<p:pipe port="network" step="filter-sapling-by-network" />
	</p:variable>

	<p:xslt> 
		<p:with-input port="source" />
		<p:with-input port="stylesheet">
			<p:document href="filter_sapling_by_network.xsl" />
		</p:with-input>
		<p:with-option name="parameters" select="map{'core-people-ids': $core-people-ids}" />
	</p:xslt>	

	<tcy:debug file-extension="pre-reinclude.xml"  />   

	<tcy:re-include-referenced-entities />
	
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
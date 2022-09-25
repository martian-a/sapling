<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    name="sapling-consistency-checks"
    type="tcy:sapling-consistency-checks"
    version="3.0">
    
	<p:import href="../../build/utils/collate-output-file-locations/collate-output-file-locations.xpl" />
	<p:import href="../../build/utils/store.xpl" />
	<p:import href="../../build/utils/debug.xpl" />
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="true"/>
    
    <p:option name="path-to-output-folder" required="false" />
	<p:option name="generated-by-user" required="false" />    
	<p:option name="debug" select="'true'" />
	
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
	<p:variable name="dataset-id" select="/*/prov:document/@xml:id" />
	<p:variable name="dataset-name" select="/*/void:dataset/@void:name" />
	<p:variable name="resource-base-uri" select="concat('http://ns.thecodeyard.co.uk/data/sapling/', $dataset-id, '/')" />     
        
        
    <p:xslt name="location-names">
        <p:with-input port="stylesheet">
            <p:document href="location_names.xsl" />
        </p:with-input>
    	<p:with-option name="parameters" select="map{'resource-base-uri' : $resource-base-uri}" />
    </p:xslt>
	
	<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="consistency-checks/location_names" name="store-location-names">
		<p:with-option name="serialization" select="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}" />
	</tcy:store>
	
	<p:sink />
	
	<tcy:collate-output-file-locations>
		<p:with-input port="source">
			<p:pipe port="result-uri" step="store-location-names" />
		</p:with-input>
	</tcy:collate-output-file-locations>
       
</p:declare-step>
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="file:///home/sheila/Tools/xproc-schemas/xproc30.rnc" type="application/relax-ng-compact-syntax"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="text-to-xml"
    type="tcy:text-to-xml"
    version="3.0">
    
	<p:import href="../provenance/insert-prov-metadata.xpl" />
	<p:import href="../debug.xpl" />
	<p:import href="../store.xpl" />
    
    <p:input port="source" primary="true" content-types="text/plain" />
    <p:output port="result" sequence="true" content-types="text/xml application/xml" />
	
	<p:option name="path-to-error-log-folder" select="'../data/debug/'" required="false" />  
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
	
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
	
    <p:xslt>
        <p:with-input port="source" />
        <p:with-input port="stylesheet">
            <p:document href="text2xml.xsl" />
        </p:with-input>
    </p:xslt>     
    
    <p:group name="insert-original-source-provenance">
    
    	<!-- Add a UUID to the entity representing the original source (txt) document in the provenance metadata. -->
    	<p:add-attribute match="/file/prov:document" attribute-name="uuid" attribute-value="''" />     
    	<p:uuid match="/file/prov:document/@uuid" version="4" />
    		
    	<!-- Add a hash of the original source (txt) document to the provenance metadata. -->
    	<p:add-attribute match="/file/prov:document" attribute-name="hash" attribute-value="''" />         	
    	<p:hash algorithm="md" match="/file/prov:document/@hash">
    		<p:with-option name="value" select="serialize(/)">
    			<p:pipe port="source" step="text-to-xml" />
    		</p:with-option>
    	</p:hash>
    	      	     	    
    </p:group>    	 
	
</p:declare-step>
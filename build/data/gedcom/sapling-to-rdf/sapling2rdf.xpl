<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    name="sapling-xml-to-rdf"
    type="tcy:sapling-xml-to-rdf"
    version="3.0">
    
	<p:import href="../../provenance/insert-prov-metadata.xpl" />
	<p:import href="../debug.xpl" />
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="true" />
    
	<p:option name="generated-by-user" required="false" />    
	<p:option name="debug" select="'true'" />
	
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
	<p:variable name="dataset-id" select="/*/prov:document/@xml:id" />
	
	<!-- Add a UUID to the root element, if one doesn't already exist. -->
	<p:choose>
		<p:when test="normalize-space(/*/@uuid) = ''">
			<p:add-attribute match="/*" attribute-name="uuid" attribute-value="''" />     
			<p:uuid match="/*/@uuid" version="4" />
		</p:when>
	</p:choose>	
	
	<tcy:debug file-extension="rdf.xml">
		<p:with-option name="file-name" select="$dataset-id" />
	</tcy:debug>   
	
	<p:group name="result-provenance-metadata">
		
		<tcy:insert-prov-metadata name="prov-metadata">
			<p:with-option name="generated-by-user" select="$generated-by-user" />
			<p:with-option name="generated-by-pipeline" select="p:urify(resolve-uri(''))" />
			<p:with-option name="pipeline-start-time" select="$pipeline-start-time" />
			<p:with-option name="pipeline-end-time" select="current-dateTime()" />
			<p:with-option name="source-uri" select="p:urify(document-uri(/))">
				<p:pipe port="source" step="sapling-xml-to-rdf" />
			</p:with-option>
		</tcy:insert-prov-metadata>  
		
	</p:group>
	
	<tcy:debug file-extension="rdf.xml">
		<p:with-option name="file-name" select="$dataset-id" />
	</tcy:debug>         	
        
    <p:xslt>
        <p:with-input port="stylesheet">
            <p:document href="sapling2rdf.xsl" />
        </p:with-input>
    	<p:with-option name="parameters" select="map{'resource-base-uri' : concat('http://ns.thecodeyard.co.uk/data/sapling/', /*/prov:document/@xml:id, '/')}" />
    </p:xslt>    
	
	<tcy:debug file-extension="rdf.xml">
		<p:with-option name="file-name" select="$dataset-id" />
	</tcy:debug>         	
    
    <p:xslt name="rdf">
        <p:with-input port="stylesheet">
            <p:document href="merge.xsl" />
        </p:with-input>
    </p:xslt>   
	
	<tcy:debug file-extension="rdf.xml">
		<p:with-option name="file-name" select="$dataset-id" />
	</tcy:debug>            
       
</p:declare-step>
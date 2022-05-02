<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="insert-prov-metadata"
    type="tcy:insert-prov-metadata"
    version="3.0"> 
     
	<p:import href="../uuid/replace-id-with-uuid.xpl" />     
     
	<p:input port="source" primary="true" />
	<p:output port="result" sequence="false" />
 
	<p:option name="generated-by-user" required="true" />
	<p:option name="generated-by-pipeline" required="true" />
	<p:option name="source-uri" required="true" />
	<p:option name="pipeline-start-time" required="false" />
	<p:option name="pipeline-end-time" required="false" />		
	
	<p:add-attribute attribute-name="generated-by-user" attribute-value="{$generated-by-user}"/>
	<p:add-attribute attribute-name="generated-by-pipeline" attribute-value="{$generated-by-pipeline}"/>
	<p:add-attribute attribute-name="source-uri" attribute-value="{$source-uri}"/>	
	
	<p:add-attribute attribute-name="pipeline-start-time" attribute-value="{xs:dateTime($pipeline-start-time)}"/>
	<p:add-attribute attribute-name="pipeline-end-time" attribute-value="{xs:dateTime($pipeline-end-time)}"/>
	<p:add-attribute attribute-name="pipeline-episode" attribute-value="{p:system-property('p:episode')}"/>
	<p:add-attribute attribute-name="pipeline-locale" attribute-value="{p:system-property('p:locale')}" />
	<p:add-attribute attribute-name="pipeline-product-name" attribute-value="{p:system-property('p:product-name')}" />
	<p:add-attribute attribute-name="pipeline-product-version" attribute-value="{p:system-property('p:product-version')}" />
	<p:add-attribute attribute-name="pipeline-product-vendor-uri" attribute-value="{p:system-property('p:vendor-uri')}" />
	
	<!-- Add a UUID to the root element, if one doesn't already exist. -->
	<p:choose name="add-uuid">
		<p:when test="normalize-space(/*/@uuid) = ''">
			<p:output port="result" />
			<p:add-attribute match="/*" attribute-name="uuid" attribute-value="''" />     
			<p:uuid match="/*/@uuid" version="4" />
		</p:when>
	</p:choose>
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="create-prov-xml.xsl" />
		</p:with-input>
	</p:xslt>    
	
	<tcy:uuid>
		<p:with-input port="source" />
		<p:with-option name="replace-values" select="descendant::*/@*:id[starts-with(., 'REPLACE-')]" as="xs:string*" />
	</tcy:uuid>	
	       
</p:declare-step>
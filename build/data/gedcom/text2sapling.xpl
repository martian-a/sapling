<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="gedcom-txt-to-sapling"
    type="tcy:gedcom-txt-to-sapling"
    version="3.0">
    
    <p:import href="text-to-xml/text2xml.xpl" />
	<p:import href="xml-to-sapling/xml2sapling.xpl" />	
	
    <p:input port="source" primary="true" />    
	
    <p:output port="result" sequence="true" />
    
	<p:option name="path-to-error-log-folder" select="'../data/debug/'" required="false" />  
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
 
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
  	
	
	<tcy:gedcom-txt-to-xml name="gedcom-xml">
		<p:with-option name="path-to-error-log-folder" select="$path-to-error-log-folder" />
		<p:with-option name="generated-by-user" select="$generated-by-user" />
		<p:with-option name="debug" select="$debug" />
	</tcy:gedcom-txt-to-xml>  
	  
    <tcy:gedcom-xml-to-sapling name="sapling-xml">
    	<p:with-input port="source">
    		<p:pipe step="gedcom-xml" port="result" />
    	</p:with-input>
    	<p:with-option name="generated-by-user" select="$generated-by-user" />
    	<p:with-option name="debug" select="$debug" />
    </tcy:gedcom-xml-to-sapling>  
	
	<p:identity>
		<p:with-input port="source">
			<p:pipe port="result" step="sapling-xml" />
		</p:with-input>
	</p:identity>
	
</p:declare-step>
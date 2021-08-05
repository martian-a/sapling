<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="gedcom-txt-to-rdf"
    type="tcy:gedcom-txt-to-rdf"
    version="3.0">
    
    <p:import href="text-to-xml/text2xml.xpl" />
	<p:import href="xml-to-sapling/xml2sapling.xpl" />
	<p:import href="sapling-to-rdf/sapling2rdf.xpl" />
    <p:import href="../../../../cenizaro/tools/schematron/validate-with-schematron.xpl" />
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="true" />
    
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
 
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
 
    <tcy:gedcom-txt-to-xml name="gedcom-xml">
    	<p:with-option name="generated-by-user" select="$generated-by-user" />
    	<p:with-option name="debug" select="$debug" />
    </tcy:gedcom-txt-to-xml>  
      
    <tcy:gedcom-xml-to-sapling name="sapling-xml">
    	<p:with-option name="generated-by-user" select="$generated-by-user" />
    	<p:with-option name="debug" select="$debug" />
    </tcy:gedcom-xml-to-sapling>  
    
	<tcy:sapling-xml-to-rdf name="sapling-rdf">
		<p:with-option name="generated-by-user" select="$generated-by-user" />
		<p:with-option name="debug" select="$debug" />
	</tcy:sapling-xml-to-rdf>  
       
</p:declare-step>
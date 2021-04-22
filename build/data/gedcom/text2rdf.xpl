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
    
    <p:option name="debug" select="'true'" />
 
 
    <tcy:gedcom-txt-to-xml name="gedcom-xml" />  
      
    <tcy:gedcom-xml-to-sapling name="sapling-xml" />  
    
	<tcy:sapling-xml-to-rdf name="sapling-rdf" />  

       
</p:declare-step>
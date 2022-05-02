<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="ancestry-to-sapling"
    type="tcy:ancestry-to-sapling"
    version="3.0">
    
    <p:import href="../gedcom/text2sapling.xpl" />
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="true" />
    
	<p:option name="path-to-output-folder" required="true" />
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
 
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
 
	<tcy:gedcom-txt-to-sapling name="ancestry-gedcom">
    	<p:with-option name="generated-by-user" select="$generated-by-user" />
    	<p:with-option name="debug" select="$debug" />
    </tcy:gedcom-txt-to-sapling>  
	
	<p:store href="{$path-to-output-folder}/{/*/*:dataset/@*:name}.{translate(substring((/*/*:document/*:activity/*:startTime)[1], 1, 10), '-', '')}.sapling.xml"
		serialization="map{'method' : 'xml', 'encoding' : 'utf-8', 'indent' : 'true'}">
	</p:store>
	
</p:declare-step>
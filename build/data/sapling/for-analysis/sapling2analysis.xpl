<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="sapling-to-analysis"
    type="tcy:sapling-to-analysis"
    version="3.0">
    	
	<p:import href="../../../../analysis/who-what-when-where/who_what_when_where.xpl" />
	<p:import href="../../../../analysis/visualisations/sapling2dot.xpl" />
	<p:import href="../../../../analysis/consistency-checks/consistency_checks.xpl" />
    <p:import href="../../../../../cenizaro/tools/schematron/validate-with-schematron.xpl" />
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="true" />
    
	<p:option name="path-to-output-folder" select="'../output/'" />
	<p:option name="name-variants" select="()" />
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
 
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
    
	<tcy:who-what-when-where name="analysis-html">
		<p:with-option name="path-to-output-folder" select="$path-to-output-folder" />
		<p:with-option name="name-variants" select="$name-variants" />
		<p:with-option name="generated-by-user" select="$generated-by-user" />
		<p:with-option name="debug" select="$debug" />
	</tcy:who-what-when-where>  
	
	<p:sink />
	
	<tcy:sapling-xml-to-dot name="visualisations">
		<p:with-input port="source">
			<p:pipe port="source" step="sapling-to-analysis" />
    	</p:with-input>
		<p:with-option name="path-to-output-folder" select="$path-to-output-folder" />
		<p:with-option name="generated-by-user" select="$generated-by-user" />
		<p:with-option name="debug" select="$debug" />
	</tcy:sapling-xml-to-dot>  	
	
	<p:sink />		
       
</p:declare-step>
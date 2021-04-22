<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="sapling-xml-to-rdf"
    type="tcy:sapling-xml-to-rdf"
    version="3.0">
    
	<p:import href="../debug.xpl" />
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="true" />
    
    <p:option name="debug" select="'true'" />
	
	<p:variable name="file-name" select="/*/@name" />
    
    <p:xslt>
        <p:with-input port="stylesheet">
            <p:document href="sapling2rdf.xsl" />
        </p:with-input>
        <p:with-option name="parameters" select="map{'resource-base-uri' : concat('http://ns.thecodeyard.co.uk/data/sapling/', tokenize(file/@filename, '\.')[1], '/')}" />
    </p:xslt>    
    

    <p:xslt name="rdf">
        <p:with-input port="stylesheet">
            <p:document href="merge.xsl" />
        </p:with-input>
    </p:xslt>   
	
	<tcy:debug file-extension="rdf.xml">
		<p:with-option name="file-name" select="$file-name" />
	</tcy:debug>         
       
</p:declare-step>
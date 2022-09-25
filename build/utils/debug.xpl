<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="debug"
    type="tcy:debug"
    version="3.0">
    
    
	<p:input port="source" primary="true" />
    <p:output port="result" sequence="true"/>
    
	<p:option name="file-name" required="false" />	
	<p:option name="file-extension" select="'xml'" required="false" />
    <p:option name="debug" select="'true'" />
	
	<p:variable name="inferred-file-name" select="(if (/*/@uuid) then concat('SAP-', /*/@uuid) else (), /*/prov:document/@xml:id)[1]" />
    
    <p:choose name="debug-output">
        <p:when test="$debug = 'true'">
        	<p:store href="../data/debug/{($file-name, $inferred-file-name)[1]}.{$file-extension}" serialization="map{'method' : 'xml', 'encoding' : 'utf-8', 'indent' : 'true'}" />
        </p:when>
        <p:otherwise>
            <p:identity />
        </p:otherwise>
    </p:choose>
       
</p:declare-step>
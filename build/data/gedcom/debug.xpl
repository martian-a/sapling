<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="debug"
    type="tcy:debug"
    version="3.0">
    
    <p:input port="source" primary="true" />
    <p:output port="result" sequence="true" />
    
	<p:option name="file-name" required="false" />
	<p:option name="file-extension" select="'xml'" required="false" />
    <p:option name="debug" select="'true'" />
 
 	<p:variable name="inferred-filename" select="/*/@name" />
    
    <p:choose>
        <p:when test="$debug = 'true'">
        	<p:store href="debug/{if (normalize-space($file-name) = '') then $inferred-filename else $file-name}.{$file-extension}"
                serialization="map{'method' : 'xml', 'encoding' : 'utf-8', 'indent' : 'true'}" name="store">
            </p:store>
        </p:when>
        <p:otherwise>
            <p:identity />
        </p:otherwise>
    </p:choose>
       
</p:declare-step>
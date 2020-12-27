<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="debug"
    type="tcy:debug"
    version="3.0">
    
    <p:input port="source" primary="true" />
    <p:output port="result" sequence="true" />
    
    <p:option name="debug" select="'true'" />
 
    
    <p:choose>
        <p:when test="$debug = 'true'">
            <p:store href="../debug/{string-join((tokenize(/*/@filename, '\.')[position() != last()], 'xml'), '.')}"
                serialization="map{'method' : 'xml', 'encoding' : 'utf-8', 'indent' : 'true'}">
            </p:store>
        </p:when>
        <p:otherwise>
            <p:identity />
        </p:otherwise>
    </p:choose>
       
</p:declare-step>
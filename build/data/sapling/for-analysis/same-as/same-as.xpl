<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="same-as"
    type="tcy:same-as"
    version="3.0">
    
    <p:input port="source" primary="true" />    
    <p:option name="other-graph-hrefs" required="true" />
    <p:output port="result" primary="true" />   
  
    <p:identity message="Checking for people in {$other-graph-hrefs[1]}..." />
  
    <p:xslt>       
        <p:with-input href="match.xsl" port="stylesheet" />
        <p:with-option name="parameters" select="map{'other-graph-href' : $other-graph-hrefs[1]}" />
    </p:xslt>   
    
    <p:choose>
        <p:when test="count($other-graph-hrefs) > 1">
            <tcy:same-as>
                <p:with-option name="other-graph-hrefs" select="$other-graph-hrefs[position() > 1]" /> 
            </tcy:same-as>
        </p:when>
        <p:otherwise>
            <p:identity />
        </p:otherwise>
    </p:choose>
    
</p:declare-step>
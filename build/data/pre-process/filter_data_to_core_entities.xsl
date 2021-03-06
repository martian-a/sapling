<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:include href="../../utils/identity.xsl" />
    
    <xsl:output encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />
    
   
    <xsl:template match="/">
        <xsl:result-document>
            <xsl:apply-templates />
        </xsl:result-document>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>
            <doc:p>Remove the include element.</doc:p>
        </doc:desc>
        <doc:note>
            <doc:p>Children of this element should become children of the data element instead.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="/app/data/include">
        
        <xsl:apply-templates select="node()" />
        
    </xsl:template>
   
    
    <doc:doc>
        <doc:desc>
            <doc:p>Suppress all non-core entities.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="/app/data/exclude" />
    
</xsl:stylesheet>
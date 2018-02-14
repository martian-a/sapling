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
            <doc:p>Suppress event records that don't involve a person who is due to be published.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="event[@id]" priority="10">
 
        <xsl:variable name="references-to-core-people" select="descendant::*[@ref = /app/data/people/person/@id]" />
 
        <xsl:if test="count($references-to-core-people) &gt; 0">
            <xsl:next-match />
        </xsl:if>
    </xsl:template>	
    
    
</xsl:stylesheet>
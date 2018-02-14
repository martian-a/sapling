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
            <doc:p>Suppress references to person records that aren't explicitly set to publish.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="person[@ref] | parent[@ref]" priority="10">
        
        <xsl:choose>
            <xsl:when test="@ref = /app/data/people/person/@id">
                <xsl:next-match />
            </xsl:when>
            <xsl:when test="ancestor::note">
                <xsl:choose>
                    <xsl:when test="normalize-space(.) = ''">[name witheld]"</xsl:when>
                    <xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise />
        </xsl:choose>
    </xsl:template>	
    
    
</xsl:stylesheet>
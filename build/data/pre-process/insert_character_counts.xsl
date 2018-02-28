<?xml-model href="http://ns.thecodeyard.co.uk/schema/cinnamon.sch?v=0.1.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" 
    version="2.0">
    
    
    <doc:doc scope="stylesheet">
        <doc:title>Character Counts</doc:title>
        <doc:desc>Count and record the number of characters in specific bodies of content.</doc:desc>
    </doc:doc>
    
    
    <xsl:include href="../../utils/identity.xsl" />
    
    
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>
    
    
    <xsl:template match="body[ancestor::source]">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="length">
                <xsl:variable name="character-count" select="string-length(xs:string(.))" />
                <xsl:choose>
                    <xsl:when test="$character-count &gt; 2000">long</xsl:when>
                    <xsl:when test="$character-count &gt; 1000">medium</xsl:when>
                    <xsl:when test="$character-count &gt; 500">short</xsl:when>
                    <xsl:otherwise>micro</xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
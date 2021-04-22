<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
       
    <xsl:template match="SOUR" mode="#all" priority="10">
        <xsl:choose>
            <xsl:when test="starts-with(value, '@') and ends-with(value, '@')">
            	<source-citation ref="{substring(value/text(), 2, string-length(value/text()) - 2)}">
                    <xsl:apply-templates select="@*" />
                    <xsl:apply-templates select="_APID" mode="ancestry" />
                    <xsl:apply-templates mode="source" />
                </source-citation>
            </xsl:when>
            <xsl:otherwise>
                <source-description>
                    <xsl:apply-templates select="@*" />
                    <xsl:apply-templates select="_APID" mode="ancestry" />
                    <xsl:apply-templates mode="source-description" />
                </source-description>
            </xsl:otherwise>
        </xsl:choose>

    </xsl:template>
    
    <xsl:template match="_APID" mode="ancestry">
        <xsl:attribute name="ancestry-proprietary-id"><xsl:apply-templates mode="#current" /></xsl:attribute>
    </xsl:template>
    
    <xsl:template match="_APID" mode="source source-description" />
    
    <xsl:template match="SOUR/value" mode="source" />
    
    <xsl:template match="SOUR/EVEN/value" mode="source" priority="10">
        <type>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates mode="#current" />
        </type>
    </xsl:template>    
    
    
    <xsl:template match="SOUR/DATA" mode="source" priority="10">
        <data-entry>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates mode="#current" />
        </data-entry>
    </xsl:template>
    
    <xsl:template match="SOUR/DATA/DATE" mode="source" priority="10">
        <date-recorded>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates mode="#current" />
        </date-recorded>
    </xsl:template>    
    
</xsl:stylesheet>
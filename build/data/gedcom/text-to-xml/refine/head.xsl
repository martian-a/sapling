<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
       
    <xsl:template match="HEAD">
        <head>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates mode="head" />
        </head>
    </xsl:template>
     
    <xsl:template match="HEAD/SOUR" mode="head">
        <source><xsl:apply-templates mode="#current" /></source>
    </xsl:template> 
     
    <xsl:template match="SOUR/NAME" mode="head">
        <name-of-product><xsl:apply-templates mode="#current" /></name-of-product>
    </xsl:template> 
        
    <xsl:template match="SOUR/value" mode="head">
        <approved-system-id><xsl:apply-templates mode="#current" /></approved-system-id>
    </xsl:template>
    
    <xsl:template match="SOUR/DATA/DATE" mode="head">
        <publication-date><xsl:apply-templates mode="#current" /></publication-date>
    </xsl:template>
    
    <xsl:template match="HEAD/DATE" mode="head">
        <transmission-date><xsl:apply-templates mode="#current" /></transmission-date>
    </xsl:template>
    
    <xsl:template match="HEAD/PLAC" mode="head">
        <place-hierarchy><xsl:value-of select="FORM" /></place-hierarchy>
    </xsl:template>
    
    <xsl:template match="HEAD/NOTE" mode="head">
        <gedcom-content-description><xsl:apply-templates mode="#current" /></gedcom-content-description>
    </xsl:template>
    
    
</xsl:stylesheet>
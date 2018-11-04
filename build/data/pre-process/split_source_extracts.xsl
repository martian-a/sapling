<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
    
    
    <xsl:template match="/app/data/sources/source[body-matter/count(extract[normalize-space(@id) != '']) > 1]">
        
        <xsl:for-each select="body-matter/extract">
        	<xsl:apply-templates select="ancestor::source[1]" mode="split-source-extracts">
        		<xsl:with-param name="extract" select="self::extract" as="element()" tunnel="yes" />
        	</xsl:apply-templates>
        </xsl:for-each>       
               
   </xsl:template>
    
    
	<xsl:template match="/app/data/sources/source/body-matter/extract[1]" mode="split-source-extracts">
		<xsl:param name="extract" as="element()" tunnel="yes" />
		
		<xsl:apply-templates select="$extract" />
	</xsl:template>


	<xsl:template match="/app/data/sources/source/body-matter/extract[position() != 1]" mode="split-source-extracts" />
		
	
	<xsl:template match="element()" mode="split-source-extracts">
		<xsl:copy><xsl:apply-templates select="attribute(), node()" mode="#current" /></xsl:copy>
	</xsl:template>
	
	<xsl:template match="processing-instruction() | comment() | attribute() | text()" mode="split-source-extracts">
		<xsl:copy><xsl:apply-templates select="node()" mode="#current" /></xsl:copy>
	</xsl:template>
    
    
</xsl:stylesheet>
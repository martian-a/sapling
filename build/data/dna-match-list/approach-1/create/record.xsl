<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">             
	
	<xsl:import href="../../../../utils/identity.xsl" />
	
	<xsl:output indent="yes" />    
    
    <xsl:template match="line" priority="10">
        <xsl:choose>        	
        	<xsl:when test="normalize-space(.) = ''" />
        	<xsl:otherwise>
        		<xsl:element name="{if (not(preceding-sibling::line[normalize-space() != ''])) then 'header' else 'record'}">
        			<xsl:apply-templates select="@*" />
        			<xsl:next-match />
        		</xsl:element>
        	</xsl:otherwise>
        </xsl:choose>
    </xsl:template>
	
	<xsl:template match="line">
		<xsl:for-each select="tokenize(., codepoints-to-string(9))">
			<element><xsl:copy-of select="." /></element>
		</xsl:for-each>
	</xsl:template>
    
</xsl:stylesheet>
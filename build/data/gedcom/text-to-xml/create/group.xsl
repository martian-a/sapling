<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">                   
    
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:copy-of select="@*" />
        	<xsl:copy-of select="*[namespace-uri() != '']" />
            <xsl:apply-templates select="record[line]" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="record[line]">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:for-each-group select="line" group-starting-with="self::*[not(@level = preceding-sibling::*[1]/@level)]">
                <group level="{current-group()[1]/@level}">
                    <xsl:copy-of select="current-group()" />
                </group>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>  
    
</xsl:stylesheet>

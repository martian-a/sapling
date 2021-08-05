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
            <xsl:for-each select="record">
                <xsl:variable name="type" select="line[1]/tokenize(normalize-space(.), ' ')[last()]" as="xs:string" />
                <xsl:variable name="id" select="line[1]/tokenize(normalize-space(.), ' ')[starts-with(., '@') and ends-with(., '@')]" as="xs:string?" />
                <xsl:copy>
                    <xsl:copy-of select="@*" />
                    <xsl:attribute name="type" select="$type" />
                    <xsl:if test="$id">
                        <xsl:attribute name="id" select="$id" />
                    </xsl:if>                       
                    <xsl:apply-templates select="line[position() &gt; 1][text()]" />                       
                </xsl:copy>
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="record/line">
        <xsl:choose>
            <xsl:when test="starts-with(., '&lt;')">
                <line><xsl:value-of select="." /></line>                
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="level" select="tokenize(., ' ')[1]" as="xs:string" />
                <xsl:variable name="label" select="tokenize(., ' ')[2]" as="xs:string" />
                <line level="{$level}" label="{$label}"><xsl:value-of select="tokenize(., ' ')[position() &gt; 2]" /></line>
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
</xsl:stylesheet>
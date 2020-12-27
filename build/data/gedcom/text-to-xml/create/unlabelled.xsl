<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">                   
    
    <xsl:template match="document-node() | element() | comment() | processing-instruction()" mode="#all">
        <xsl:copy>
            <xsl:copy-of select="@*[normalize-space(.) != '']" />
            <xsl:if test="self::*:line/normalize-space(@level) = ''"><xsl:attribute name="level" select="preceding-sibling::*:line[1]/@level" /></xsl:if>
            <xsl:if test="self::*:line/normalize-space(@label) = ''"><xsl:attribute name="label" select="preceding-sibling::*:line[1]/@label" /></xsl:if>
            <xsl:apply-templates mode="#current"/>
        </xsl:copy>
    </xsl:template> 
    
</xsl:stylesheet>
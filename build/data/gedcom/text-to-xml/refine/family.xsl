<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
       
    <xsl:template match="FAM">
        <family>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates mode="family" />
        </family>
    </xsl:template>
    
    
    <xsl:template match="CHIL" mode="family">
        <child ref="{value/text()}">
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates mode="#current" />
        </child>
    </xsl:template>
    
</xsl:stylesheet>
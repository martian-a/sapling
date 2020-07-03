<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
       
    <xsl:template match="INDI">
        <individual>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates mode="individual" />
        </individual>
    </xsl:template>
    
    <xsl:template match="INDI/NAME" mode="individual">
        <name>
            <personal-name><xsl:apply-templates select="value/node()" mode="#current" /></personal-name>
            <xsl:apply-templates select="*[local-name() != 'value']" mode="#current" />
        </name>
    </xsl:template>     
    
</xsl:stylesheet>
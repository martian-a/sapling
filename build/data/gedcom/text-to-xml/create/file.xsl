<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">                   
    
    <xsl:output indent="yes" />
    
    <xsl:template match="text()">
        <file href="{document-uri(/)}" filename="{tokenize(translate(document-uri(/), '\', '/'), '/')[last()]}">
            
            <xsl:for-each select="tokenize(., '&#xD;')">
                <line><xsl:value-of select="translate(., codepoints-to-string(10), '')" /></line>
            </xsl:for-each>
            
        </file>
    </xsl:template>
    
</xsl:stylesheet>
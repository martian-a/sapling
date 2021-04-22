<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    
    
    <xsl:template match="PLAC/value/text() | PLAC/text()" mode="#all">
        <place-name><xsl:value-of select="." /></place-name>        
    </xsl:template>
    
    <xsl:template match="PLAC/FORM" mode="#all">
        <place-hierarchy><xsl:apply-templates /></place-hierarchy>        
    </xsl:template>
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="3.0">
        
    <xsl:template match="*" mode="#default notes people">
        <xsl:apply-templates mode="#current" />
    </xsl:template>
    
    <xsl:template match="text()" />
    
</xsl:stylesheet>
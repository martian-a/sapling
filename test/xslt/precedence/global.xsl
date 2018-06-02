<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="defaults.xsl"/>
    <xsl:include href="view.xsl"/>
    
    
    <xsl:output method="xml" indent="yes" />
    
    <xsl:template match="/">
        <result matched="/" priority="0">
            <inline>global.xsl</inline>
            <xsl:next-match />
        </result>
    </xsl:template>
    
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:import href="defaults_sub_1.xsl" />
    <xsl:import href="defaults_sub_2.xsl" />
    
    <xsl:template match="/">
        <result matched="/" priority="0">
            <inline>defaults.xsl</inline>
            <xsl:next-match />
        </result>
    </xsl:template>
    
    <xsl:template match="/" priority="100">
        <result matched="/" priority="100">
            <inline>defaults.xsl</inline>
            <xsl:next-match />
        </result>
    </xsl:template>
    
    
</xsl:stylesheet>
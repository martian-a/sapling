<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:template match="value[not(starts-with(., '@') and ends-with(., '@'))]" mode="#all">
        <value>
            <xsl:apply-templates />
            <xsl:for-each select="following-sibling::*[local-name() = ('CONT', 'CONC')]">
                <xsl:if test="local-name() = 'CONT'"><br /></xsl:if>
                <xsl:apply-templates />
            </xsl:for-each>
            <xsl:apply-templates select="following-sibling::*[local-name() = ('value', 'CONT', 'CONC')]" />
        </value>
    </xsl:template>
    
    <xsl:template match="CONC | CONT" mode="#all" />
            
    <xsl:template match="value[not(text()) and not(*)]" priority="2" mode="#all" />                   
    
</xsl:stylesheet>
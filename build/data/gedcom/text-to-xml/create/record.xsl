<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">             
	
	<xsl:output indent="yes" />    
    
    <xsl:template match="/*">
        <xsl:copy>
            <xsl:copy-of select="@*" />
        	<xsl:copy-of select="*[namespace-uri() != '']" />
            <xsl:for-each-group select="line" group-starting-with="self::*[starts-with(., '0 ')]" >
                <record>
                    <xsl:copy-of select="current-group()" />
                </record>
            </xsl:for-each-group>
        </xsl:copy>
    </xsl:template>
    
</xsl:stylesheet>
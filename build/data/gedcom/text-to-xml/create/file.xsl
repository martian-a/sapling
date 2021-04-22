<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="2.0">                   

	<xsl:param name="generated-by-user" select="''" />
	<xsl:param name="generated-by-pipeline" select="''" />
	<xsl:param name="transformation-start-time" select="current-dateTime()" />
	<xsl:param name="transformation-id" select="generate-id()" />
	<xsl:param name="filename" select="string-join(tokenize(tokenize(translate(document-uri(/), '\', '/'), '/')[last()], '\.')[position() != last()], '.')" />
	<xsl:param name="dataset-id" select="$filename" />

    <xsl:output indent="yes" />
    
    <xsl:template match="text()">
    	<file stylesheet-uri="{resolve-uri('')}" transformation-start-time="{$transformation-start-time}" transformation-id="{$transformation-id}" derived-from="{document-uri(/)}" dataset-id="{$dataset-id}">
    		<xsl:if test="normalize-space($generated-by-pipeline) != ''">
    			<xsl:attribute name="generated-by-pipeline" select="$generated-by-pipeline" />
    		</xsl:if>
    		<xsl:if test="normalize-space($generated-by-user) != ''">
    			<xsl:attribute name="generated-by-user" select="$generated-by-user" />
    		</xsl:if>
            
            <xsl:for-each select="tokenize(., '&#xD;')">
                <line><xsl:value-of select="translate(., codepoints-to-string(10), '')" /></line>
            </xsl:for-each>
            
        </file>
    </xsl:template>
    
</xsl:stylesheet>
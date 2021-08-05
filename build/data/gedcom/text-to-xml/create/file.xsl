<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="2.0">                   

	<xsl:param name="source-uri" select="document-uri(/)" />
	<xsl:param name="dataset-name" select="tokenize(tokenize(translate($source-uri, '\', '/'), '/')[last()], '\.')[1]" />

    <xsl:output indent="yes" />
    
    <xsl:template match="text()">
    	<file>
    		<void:dataset void:name="{$dataset-name}" />
    		<prov:document>
    			<prov:location><xsl:value-of select="$source-uri" /></prov:location>
    		</prov:document>
            
            <xsl:for-each select="tokenize(., '&#xD;')">
                <line><xsl:value-of select="translate(., codepoints-to-string(10), '')" /></line>
            </xsl:for-each>
            
        </file>
    </xsl:template>
    
</xsl:stylesheet>
<xsl:stylesheet 
	xmlns:gw="http://ns.greenwood.thecodeyard.co.uk/xslt/functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
    
    
	<xsl:template match="*" mode="link.html">
		<xsl:value-of select="."/>
	</xsl:template>
	
	<xsl:template match="*" mode="link.xml">
		<xsl:text>XML</xsl:text>
	</xsl:template>
    
	<xsl:template match="/app/view" mode="html.body.title">
		<xsl:apply-templates select="self::*" mode="view.title"/>
	</xsl:template>
    
</xsl:stylesheet>
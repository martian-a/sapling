<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" version="2.0">
	  
    
	<doc:doc>
		<doc:desc>
			<doc:p>HTML document structure.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="*" mode="html.header html.header.scripts html.header.style html.footer.scripts" />
    
    
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
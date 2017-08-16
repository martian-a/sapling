<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	
	<xsl:output encoding="UTF-8" indent="yes" method="xml" />
		
	<xsl:template match="/">
		<xsl:variable name="prefix" select="translate(//*[@id][1]/@id, '0123456789', '')" as="xs:string?" />
		<xsl:variable name="used" as="element()*">
			<xsl:for-each select="distinct-values(//*/@id/xs:integer(substring-after(., $prefix)))">
				<xsl:sort select="." data-type="number" order="ascending" />
				<number><xsl:value-of select="." /></number>
			</xsl:for-each> 
		</xsl:variable>
		
		<next>
			<xsl:for-each select="$used">
				<xsl:variable name="current" select="xs:integer(.)" />
				<xsl:variable name="next" select="$current + 1" />
				<xsl:if test="not(following-sibling::*[. = $next])">
					<unused><xsl:value-of select="concat($prefix, $next)" /></unused>
				</xsl:if>
			</xsl:for-each>
		</next>
		
	</xsl:template>
	
</xsl:stylesheet>
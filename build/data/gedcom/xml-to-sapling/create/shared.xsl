<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="3.0">
	
	<xsl:template match="source-citation" mode="reference" priority="10">
		<source ref="{@ref}">
			<summary><xsl:next-match /></summary>
		</source>
	</xsl:template>
	
	<xsl:template match="birth/value" mode="notes">
		<note>
			<p><xsl:value-of select="." /></p>
		</note>
	</xsl:template>	
		
	
</xsl:stylesheet>
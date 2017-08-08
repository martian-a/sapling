<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	
	<xsl:template match="/">
		<xsl:result-document>
			<xsl:apply-templates />
		</xsl:result-document>
	</xsl:template>
	
	<xsl:template match="app/data" />	
	
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="node()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@* | comment() | processing-instruction()">
		<xsl:copy-of select="." />
	</xsl:template>
	
</xsl:stylesheet>
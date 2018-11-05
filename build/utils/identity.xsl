<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	version="2.0">
		
	<xsl:template match="element()">
		<xsl:copy copy-namespaces="no"><xsl:apply-templates select="attribute(), node()" /></xsl:copy>
	</xsl:template>
	
	<xsl:template match="processing-instruction() | comment() | attribute() | text()">
		<xsl:copy><xsl:apply-templates select="node()" /></xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
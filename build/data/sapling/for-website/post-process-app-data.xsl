<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:preserve-space elements="*" />
	
	<xsl:template match="/">
		<xsl:result-document>
			<xsl:apply-templates />
		</xsl:result-document>
	</xsl:template>	
	
	<!-- Suppress embedded data as it's being published separately. -->
	<xsl:template match="/app/data/node()" />	
	
	
	
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
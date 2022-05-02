<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:output encoding="UTF-8" indent="yes" />
	
	<xsl:template match="/locations">
		<locations>
			<xsl:apply-templates select="//location" />
		</locations>
	</xsl:template>
	
	<xsl:template match="location">
		<location>
			<xsl:copy-of select="@*" />
			<xsl:copy-of select="name" />
			<xsl:apply-templates select="parent::location" mode="parent" />
		</location>
	</xsl:template>
	
	<xsl:template match="location" mode="parent">
		<within ref="{@id}" />
	</xsl:template>
	
</xsl:stylesheet>
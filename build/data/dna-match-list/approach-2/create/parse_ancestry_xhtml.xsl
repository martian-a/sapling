<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xhtml="http://www.w3.org/1999/xhtml"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	expand-text="true"
	version="3.0">
	
	<xsl:output indent="true" suppress-indentation="p" method="xml" /> 
	
	<xsl:template match="/">
		<dna-data>
			<xsl:apply-templates select="xhtml:html/xhtml:body/xhtml:table[position() > 1]" />
		</dna-data>
	</xsl:template>
	
	
	<xsl:template match="xhtml:html/xhtml:body/xhtml:table">
		<xsl:for-each-group select="xhtml:tr/xhtml:td/xhtml:p" group-ending-with="self::*[starts-with(., 'Paternal ')]">
			<match>
				<xsl:apply-templates select="current-group()" />
			</match>
		</xsl:for-each-group>
	</xsl:template>
	
	<xsl:template match="xhtml:a/@shape" priority="10" />
	<xsl:template match="xhtml:a[normalize-space(.) = ''][@href = following-sibling::*[1][local-name() = 'a']/@href]" priority="10" />
	<xsl:template match="xhtml:p[lower-case(normalize-space(.)) = 'distant family']" priority="10" />
	
	<xsl:template match="element()[ancestor-or-self::xhtml:p]">
		<xsl:element name="{name()}">
			<xsl:apply-templates select="@*, node()" />
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="attribute()[ancestor-or-self::xhtml:p]">
		<xsl:attribute name="{name()}">
			<xsl:value-of select="." />
		</xsl:attribute>
	</xsl:template>
	
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	expand-text="true"
	version="3.0">
	
	<xsl:output indent="true" />
	
	<xsl:param name="anchor-person-id" select="'I432064074593'" />
	
	<xsl:template match="/">
		<pedigree>
			<xsl:apply-templates select="/data/people/person[@id = $anchor-person-id]">
				<xsl:with-param name="generation-index" select="0" as="xs:integer" tunnel="true" />
				<xsl:with-param name="person-position" select="1" as="xs:integer" tunnel="true" />
			</xsl:apply-templates>
		</pedigree>
	</xsl:template>
	
	
	<xsl:template match="people/person">
		<xsl:param name="generation-index" as="xs:integer" tunnel="true" />
		<xsl:param name="person-position" as="xs:integer" tunnel="true" />
		
		<xsl:copy>
			<xsl:attribute name="generation-index" select="$generation-index" />
			<xsl:attribute name="position" select="$person-position" />
			<xsl:apply-templates select="@id, persona[1], gender" />
			<parents>
				<xsl:apply-templates select="/data/events/event[@type = 'birth'][person/@ref = current()/@id]">
					<xsl:with-param name="generation-index" select="$generation-index + 1" as="xs:integer" tunnel="true" />
					<xsl:with-param name="parent-position" select="$person-position" as="xs:integer" tunnel="true" />
				</xsl:apply-templates>
			</parents>
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="events/event">
		<xsl:param name="generation-index" as="xs:integer" tunnel="true" />
		<xsl:param name="parent-position" as="xs:integer" tunnel="true" />
		
		<xsl:apply-templates select="parent" />
		<xsl:if test="count(parent) &lt; 2">
			<xsl:for-each select="1 to (2 - count(parent))">
				<person position="{(($parent-position -1) * 2) + position()}" />
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="event/parent">
		<xsl:param name="generation-index" as="xs:integer" tunnel="true" />
		<xsl:param name="parent-position" as="xs:integer" tunnel="true" />
		
		<xsl:apply-templates select="/data/people/person[@id = current()/@ref]">
			<xsl:with-param name="person-position" select="(($parent-position -1) * 2) + count(preceding-sibling::parent) + 1" as="xs:integer" tunnel="true" />
		</xsl:apply-templates>
	</xsl:template>
	
	
	<xsl:template match="element()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="attribute()">
		<xsl:copy />
	</xsl:template>
	
</xsl:stylesheet>
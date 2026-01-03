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
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:template match="match">
		<match shared-cm="{substring-before(substring-after(p[2], 'Paternal side'), ' cM |')}">
			<xsl:if test="p[text()/starts-with(., 'Managed by')]">
				<xsl:attribute name="manager" select="p/text()[starts-with(., 'Managed by')]/substring-after(., 'Managed by ')" />
			</xsl:if>
			<xsl:apply-templates select="p[1]/a" />
			<xsl:apply-templates select="p[2]" mode="tree" />
		</match>
	</xsl:template>
	
	
	<xsl:template match="p[1]/a">
		<user profile="{@href}"><xsl:apply-templates /></user>	
	</xsl:template>
	
	
	<xsl:template match="p" mode="tree">
		<xsl:if test="not(contains(., 'No trees'))">
			<tree common-ancestor="{if (contains(., 'Common ancestor')) then 'true' else 'false'}">
				<xsl:variable name="type" select="substring-before(substring-after(., 'shared DNA'), ' tree')" as="xs:string" />
				<xsl:attribute name="linked" select="if (contains($type, 'linked')) then 'true' else 'false'" />
				<xsl:attribute name="public" select="if (contains($type, 'Public')) then 'true' else 'false'" />
				<xsl:if test="contains($type, 'Public')">
					<xsl:attribute name="people" select="substring-before(substring-after(., ' tree'), ' people')" /> 
				</xsl:if>
			</tree>	
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="match/p[1][starts-with(text(), 'Managed by')]" />
		

	<xsl:template match="node() | attribute()">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
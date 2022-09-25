<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<!-- Only one ID is expected. -->
	<xsl:param name="anchor-person-id" required="no" />	
	
	<xsl:output encoding="UTF-8" indent="yes" />
	<xsl:strip-space elements="*" />
	
	<xsl:import href="../../../utils/identity.xsl" />
	
	<xsl:template match="network" priority="10">			
		<xsl:next-match>
			<xsl:with-param name="filtered-edges" as="element()*" tunnel="yes">
				<xsl:apply-templates select="edges/edge/node[@role = 'target'][@ref = $anchor-person-id]" mode="filter" />
			</xsl:with-param>
		</xsl:next-match>		
	</xsl:template>
	
	<xsl:template match="edges">
		<xsl:param name="filtered-edges" as="element()*" tunnel="yes" />
		
		<xsl:copy>
			<xsl:apply-templates select="@*, $filtered-edges" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="nodes">
		<xsl:param name="filtered-edges" tunnel="yes" />
		
		<xsl:copy>
			<xsl:apply-templates select="@*, node[@id = $filtered-edges/node/@ref]" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="edge/node" mode="filter">
		<xsl:variable name="parent-id" select="parent::edge/node[@role = 'source']/@ref" as="xs:string" />
			
		<xsl:apply-templates select="parent::edge" />
		<xsl:apply-templates select="ancestor::edges[1]/edge/node[@role = 'target'][@ref = $parent-id]" mode="filter" />
	</xsl:template>
	
</xsl:stylesheet>
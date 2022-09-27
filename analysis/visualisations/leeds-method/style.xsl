<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<!-- Only one ID is expected. -->
	<xsl:param name="anchor-person-id" required="no" />
	<xsl:param name="dna-match-ids" required="no" />	
	
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />
	<xsl:strip-space elements="*" />
	
	<xsl:import href="../../../build/utils/identity.xsl" />
	

	<xsl:template match="network" priority="10">			
		<xsl:next-match>
			<xsl:with-param name="filtered-edges" as="element()*" tunnel="yes">
				<xsl:apply-templates select="edges/edge/node[@role = 'target'][@ref = $anchor-person-id]" mode="filter" />
			</xsl:with-param>
		</xsl:next-match>		
	</xsl:template>
	
	<xsl:template match="edge">
		<xsl:param name="filtered-edges" as="element()*" tunnel="yes" />
		
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:if test="@id = $filtered-edges/@id">
				<xsl:attribute name="class" select="'lineage-1'" />
			</xsl:if>
			<xsl:apply-templates select="node()" />
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="node[@id = $anchor-person-id]">		
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:attribute name="class" select="'dna-subject'" />			
			<xsl:apply-templates select="node()" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="node[@id = $dna-match-ids]">		
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:attribute name="class" select="'dna-match'" />			
			<xsl:apply-templates select="node()" />
		</xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="edge/node" mode="filter">
		<xsl:variable name="parent-id" select="parent::edge/node[@role = 'source']/@ref" as="xs:string" />
			
		<xsl:apply-templates select="parent::edge" />
		<xsl:apply-templates select="ancestor::edges[1]/edge/node[@role = 'target'][@ref = $parent-id]" mode="filter" />
	</xsl:template>
	
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	exclude-result-prefixes="#all"
	version="2.0">
		
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />
	<xsl:strip-space elements="*" />
	
	<xsl:import href="../../../utils/identity.xsl" />
	

	<xsl:template match="/networks">
		<xsl:apply-templates select="network[1]" mode="metadata" />
	</xsl:template>
	
	<xsl:template match="network" mode="metadata">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="node()[not(local-name() = ('nodes', 'edges'))]" />
			<nodes>
				<xsl:for-each-group select="/networks/network/nodes/node" group-by="@id">
					<xsl:apply-templates select="current-group()[1]" /> 
				</xsl:for-each-group>
			</nodes>
			<edges>
				<xsl:for-each-group select="/networks/network/edges/edge" group-by="@id">
					<xsl:apply-templates select="current-group()[1]" /> 
				</xsl:for-each-group>
			</edges>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="network/@subset-name" />
	
</xsl:stylesheet>
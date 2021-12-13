<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" /> 
	
	<xsl:template match="/data">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
			<serials>
				<xsl:copy-of select="descendant::serial[@id]" />
			</serials>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="serial[@id]" />
	
	<xsl:template match="/data/people/person/sources/source[@id]" />
	
	<xsl:template match="/data/sources">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
			<xsl:copy-of select="/data//source[@id][not(ancestor::sources/parent::data)]" />
		</xsl:copy>
	</xsl:template>
	
	
	
    <xsl:include href="../../../../utils/identity.xsl" />
    
</xsl:stylesheet>
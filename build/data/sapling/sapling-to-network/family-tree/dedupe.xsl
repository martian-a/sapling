<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	exclude-result-prefixes="#all"
	version="2.0">
		
	<xsl:output method="xml" encoding="UTF-8" indent="yes" />
	<xsl:strip-space elements="*" />
	
	<xsl:import href="../../../../utils/identity.xsl" />
	
	<xsl:template match="nodes | edges">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:for-each-group select="*" group-by="@id">
				<xsl:apply-templates select="current-group()[1]" /> 				
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
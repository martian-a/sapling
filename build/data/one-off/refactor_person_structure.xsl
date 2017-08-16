<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:import href="../../utils/identity.xsl" />
	
	
	<xsl:output encoding="UTF-8" indent="yes" method="xml" />
	
	
	<xsl:template match="/people/person/notes">
		<note>
			<xsl:apply-templates select="attribute(), node()" />
		</note>
	</xsl:template>
	
	
</xsl:stylesheet>
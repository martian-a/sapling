<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:import href="../../utils/identity.xsl" />


	<xsl:output encoding="UTF-8" indent="yes" method="xml" />
	

	<xsl:template match="/events/event">
		<xsl:copy>
			<xsl:apply-templates select="attribute()" />
			<xsl:apply-templates select="date, person, parent, location, summary, note" />
			<xsl:apply-templates select="*[not(name() = ('date', 'person', 'parent', 'location', 'summary', 'note'))]" />
		</xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
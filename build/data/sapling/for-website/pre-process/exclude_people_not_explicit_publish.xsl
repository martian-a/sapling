<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	exclude-result-prefixes="#all"
	version="2.0">
	
	<doc:doc>
		<doc:desc>Filter source data so only includes people explicitly set to publish.</doc:desc>
	</doc:doc>
	
	
	<xsl:include href="../../../../utils/identity.xsl" />
	
	<doc:doc>
		<doc:title>Initial template</doc:title>
		<doc:desc>
			<doc:p>Match the document root and initiate an identity transformation.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/">
		<xsl:result-document>
			<xsl:apply-templates />
		</xsl:result-document>
	</xsl:template>	
	
	
	<doc:doc>
		<doc:desc>Suppress person records that aren't explicitly set to publish, regardless of whether they're in the include or exclude collection.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/data/*/people/person[not(@publish = 'true')]" />
		
</xsl:stylesheet>
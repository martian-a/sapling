<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	exclude-result-prefixes="#all"
	version="2.0">
	
	<doc:doc scope="stylesheet">
		<doc:desc>Dereference journals.</doc:desc>
	</doc:doc>
	
	<xsl:include href="../../utils/identity.xsl" />
	
	
	<doc:doc>
		<doc:desc>Handy key for quickly finding a journal definition.</doc:desc>
	</doc:doc>
	<xsl:key name="journal" match="/app/data/journals/journal" use="@id" />
	
	
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
		<doc:desc>Match all references to a journal and replace with the actual data from the referenced journal definition.</doc:desc>
	</doc:doc>
	<xsl:template match="journal[@ref]">
		<xsl:variable name="definition" select="key('journal', @ref)" as="element()" />
		
		<xsl:copy>
			<xsl:apply-templates select="$definition/@*[name() != 'id'], $definition/node()" />
			<issue>
				<xsl:apply-templates select="@*[name() != 'ref'], node()" />
			</issue>
		</xsl:copy>
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>Suppress journal definitions.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/data/journals" />
	
</xsl:stylesheet>
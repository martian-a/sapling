<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	exclude-result-prefixes="#all"
	version="2.0">
	
	<doc:doc scope="stylesheet">
		<doc:desc>Dereference serial publications.</doc:desc>
	</doc:doc>
	
	<xsl:include href="../../utils/identity.xsl" />
	
	
	<doc:doc>
		<doc:desc>Handy key for quickly finding a serial publication definition.</doc:desc>
	</doc:doc>
	<xsl:key name="serial" match="/app/data/serials/serial" use="@id" />
	
	
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
		<doc:desc>Match all references to a serial publication and replace with the actual data from the referenced serial definition.</doc:desc>
	</doc:doc>
	<xsl:template match="serial[@ref]">
		<xsl:variable name="definition" select="key('serial', @ref)" as="element()" />
		
		<xsl:copy>
			<xsl:apply-templates select="$definition/@*[name() != 'id'], $definition/node()" />
			<xsl:if test="*">
				<part>
					<xsl:apply-templates select="@*[name() != 'ref'], node()" />
				</part>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>Suppress serial definitions.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/data/serials" />
	
</xsl:stylesheet>
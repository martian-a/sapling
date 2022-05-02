<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	exclude-result-prefixes="#all"
	version="2.0">
	
	<doc:doc>
		<doc:desc>Merge data sources.</doc:desc>
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
		<doc:desc>Merge data sources of the same kind.</doc:desc>
	</doc:doc>
	<xsl:template match="app/data">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="@*" />
			<xsl:for-each-group select="*" group-by="name()">
				<xsl:element name="{current-grouping-key()}">
					<xsl:apply-templates select="current-group()/node()" />
				</xsl:element>
			</xsl:for-each-group>
		</xsl:copy>
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>Suppress nested schema associations.</doc:desc>
	</doc:doc>
	<xsl:template match="processing-instruction()[ancestor::app][name() = 'xml-model']" />
	
</xsl:stylesheet>
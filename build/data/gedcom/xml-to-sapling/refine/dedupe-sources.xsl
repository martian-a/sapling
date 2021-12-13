<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" /> 
	
	<xsl:variable name="source-groups" as="element()">
		<source-groups>
			<xsl:for-each-group select="/data/sources/source" group-by="string-join((descendant::*/@*/text(), descendant-or-self::text()))">
				<source-group id="{generate-id()}">
					<xsl:copy-of select="current-group()" />
				</source-group>			
			</xsl:for-each-group>
		</source-groups>
	</xsl:variable>
		
	<xsl:template match="/data/sources">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
			<xsl:apply-templates select="$source-groups/source-group" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="source[@id]" />
	
	<xsl:template match="serial/author[normalize-space(.) = current()/parent::serial/publisher/normalize-space(.)]" />
	
	<xsl:template match="source-group">
		<source id="{@id}">
			<xsl:apply-templates select="source[1]/@*[name() != 'id']" />
			<xsl:apply-templates select="source[1]/node()" />
		</source>
	</xsl:template>
	
	<xsl:template match="source/@ref">
		<xsl:attribute name="ref">
			<xsl:value-of select="$source-groups/source-group/source[@id = current()]/parent::source-group/@id" />
		</xsl:attribute>
	</xsl:template>
	
    <xsl:include href="../../../../utils/identity.xsl" />
    
</xsl:stylesheet>
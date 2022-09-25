<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" /> 
	
	<xsl:template match="/" priority="10">
		
		<xsl:variable name="grouped-by-content" as="document-node()">
			<xsl:document>
				<source-groups>
					<xsl:for-each-group select="/data/sources/source" group-by="string-join((descendant::*/@*, normalize-space(self::*)))">
						<source-group id="{generate-id()}" key="{current-grouping-key()}">
							<xsl:copy-of select="current-group()" />
						</source-group>			
					</xsl:for-each-group>
				</source-groups>
			</xsl:document>
		</xsl:variable>
		
		<xsl:variable name="groups-count-added" as="document-node()">
			<xsl:document>
				<xsl:apply-templates select="$grouped-by-content" mode="add-groups-count" />
			</xsl:document>
		</xsl:variable>
		
		<xsl:variable name="source-groups" as="document-node()">
			<xsl:call-template name="group-by-id">
				<xsl:with-param name="latest-result" select="$groups-count-added" as="document-node()" />
			</xsl:call-template>			
		</xsl:variable>
		
		<xsl:next-match>
			<xsl:with-param name="source-groups" select="$source-groups" as="document-node()" tunnel="yes" />
		</xsl:next-match>
		
	</xsl:template>
	
	<xsl:template match="source[@id]" mode="add-groups-count">
		<xsl:variable name="source-id" select="@id" as="xs:string" />
		<xsl:variable name="source-elements" select="self::source, self::*/following::source[@id = $source-id]" as="element()*" />
		<xsl:variable name="source-element-ids" select="distinct-values($source-elements/@id)" as="xs:string*" />
		<xsl:variable name="group-ids" select="distinct-values(ancestor::source-groups/source-group[source/@id = $source-element-ids]/@id)" as="xs:string*" />
		<xsl:copy copy-namespaces="no">
			<xsl:attribute name="group-ids">
				<xsl:choose>
					<xsl:when test="count($group-ids) > 1"><xsl:value-of select="string-join($group-ids, ', ')" /></xsl:when>
					<xsl:otherwise><xsl:value-of select="$group-ids" /></xsl:otherwise>
				</xsl:choose>
			</xsl:attribute>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="element()" mode="add-groups-count">
		<xsl:copy copy-namespaces="no"><xsl:apply-templates select="attribute(), node()" mode="#current" /></xsl:copy>
	</xsl:template>
	
	<xsl:template match="processing-instruction() | comment() | attribute() | text()" mode="add-groups-count">
		<xsl:copy><xsl:apply-templates select="node()" mode="#current" /></xsl:copy>
	</xsl:template>
	
	
	<xsl:template name="group-by-id">
		<xsl:param name="latest-result" as="document-node()" />
		
		<xsl:choose>
			<xsl:when test="$latest-result/source-group/source[contains(@group-ids, ', ')]">
				<source-groups>
					<xsl:for-each-group select="$latest-result/source-group/source" group-by="@id">
						<source-group id="{current-group()[1]/parent::source-group/@id}">
							<xsl:copy-of select="current-group()/parent::source-group/source" />
						</source-group>			
					</xsl:for-each-group>
				</source-groups>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="$latest-result" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
		
	<xsl:template match="/data/sources">
		<xsl:param name="source-groups" as="document-node()" tunnel="yes" />
		
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
			<xsl:apply-templates select="$source-groups/source-groups/source-group" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="source[@id]" />
	
	<xsl:template match="serial/author[normalize-space(.) = current()/parent::serial/publisher/normalize-space(.)]" />
		
	<xsl:template match="source-group">
		<source id="{@id}">
			<xsl:apply-templates select="source[1]/@*[not(name() = ('id', 'group-ids'))]" />
			<xsl:apply-templates select="source[1]/node()" />
		</source>
	</xsl:template>
	
	<xsl:template match="source/@ref">
		<xsl:param name="source-groups" as="document-node()" tunnel="yes" />
		<xsl:variable name="source-id" select="." as="xs:string" />
		
		<xsl:variable name="new-id" select="($source-groups/source-groups/source-group[source/@id = $source-id]/@id)[1]" as="xs:string" />
		
		<xsl:attribute name="ref" select="$new-id" />
	</xsl:template>
	
    <xsl:include href="../../../../utils/identity.xsl" />
    
</xsl:stylesheet>
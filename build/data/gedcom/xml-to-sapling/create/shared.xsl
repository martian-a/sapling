<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="3.0">
	
	<xsl:template match="source-citation[page = 'Family Tree']" mode="reference" priority="100" />
	
	<xsl:template match="source-citation" mode="reference" priority="10">
		<xsl:variable name="citation-id" select="generate-id(self::*)" />
		<source ref="{$citation-id}">
			<summary><xsl:next-match /></summary>
		</source>
		<source id="{$citation-id}">
			<xsl:apply-templates select="self::*" mode="reference.source" />
		</source>
	</xsl:template>
	
	<xsl:template name="web-links-source-citation">
		<xsl:for-each-group select="web-link" group-by="value">
			<source ref="{current-group()[1]/value}">
				<summary><xsl:value-of select="title" /></summary>
			</source>
			<source id="{current-grouping-key()}">
				<front-matter>
					<xsl:for-each-group select="current-group()/title" group-by="text()">
						<xsl:apply-templates select="current-group()[1]" mode="reference.source" />	
					</xsl:for-each-group>
					<xsl:apply-templates select="current-group()[1]/value" mode="reference.source" />
				</front-matter>
			</source>     
		</xsl:for-each-group>
	</xsl:template>
	
	<xsl:template match="web-link/title" mode="reference.source">
		<xsl:copy-of select="self::*" copy-namespaces="false" />
	</xsl:template>	
	
	<xsl:template match="web-link/value" mode="reference.source">
		<link href="{.}" />
	</xsl:template>	
	
	
	<xsl:template match="birth/value" mode="notes">
		<note>
			<p><xsl:value-of select="." /></p>
		</note>
	</xsl:template>	
	
	<xsl:template match="fact">
		<xsl:copy>
			<xsl:copy-of select="@*" />
			<xsl:attribute name="type" select="type/text()" />
			<p><xsl:value-of select="value" /></p>
			<xsl:apply-templates select="*[not(local-name() = ('type', 'value'))]" />
		</xsl:copy>
	</xsl:template>	
	
	<xsl:template match="source-citation" mode="reference.source">
		<front-matter>
			<xsl:apply-templates select="/file/source-description[@id = current()/@ref]/title" mode="reference.source.front-matter" />					
			<xsl:apply-templates select="data-entry/date-recorded, data-entry/note" mode="reference.source.front-matter" />
			<xsl:apply-templates select="/file/source-description[@id = current()/@ref]" mode="reference.source.serial" />
			<xsl:apply-templates select="page" mode="reference.source.front-matter" />
		</front-matter>
		<xsl:apply-templates select="data-entry/text" mode="reference.source.body-matter" />
	</xsl:template>
		
	<xsl:template match="/file/source-description[@id]/title" mode="reference.source.front-matter">
		<title><xsl:value-of select="."/></title>		
	</xsl:template>		
		
	<xsl:template match="source-citation/page" mode="reference.source.front-matter">
		<note>
			<p><xsl:value-of select="."/></p>
		</note>		
	</xsl:template>		
	
	<xsl:template match="source-citation/data-entry/date-recorded" mode="reference.source.front-matter">
		<date rel="published"><xsl:value-of select="." /></date>
	</xsl:template>
	
	<xsl:template match="source-citation/data-entry/note" mode="reference.source.front-matter">
		<xsl:choose>
			<xsl:when test="starts-with(translate(lower-case(normalize-space(.)), 's', ''), 'http://')">
				<link href="{.}" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:comment><xsl:value-of select="." /></xsl:comment>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="source-citation/data-entry/text" mode="reference.source.body-matter">
		<body-matter>
			<extract>
				<xsl:if test="parent::data-entry/note[starts-with(normalize-space(.), 'p')]">
					<pages><xsl:value-of select="parent::data-entry/note" /></pages>
				</xsl:if>
				<body>
					<p><xsl:value-of select="." /></p>
				</body>
			</extract>
		</body-matter>
	</xsl:template>
	
	<xsl:template match="source-description[@id]" mode="reference.source.serial">
		<serial ref="{@id}" />
	</xsl:template>
	
</xsl:stylesheet>
<?xml-model href="http://ns.thecodeyard.co.uk/schema/cinnamon.sch?v=0.1.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
	
	<doc:doc>
		<doc:title>Key: Century</doc:title>
		<doc:desc>
			<doc:p>For quickly finding an century entity in the data, using it's ID.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="century" match="data/century | related/century | entities/century" use="@id" />
	
	
	<doc:doc>
		<doc:desc>Import style rules specific to century profiles (in the HTML header).</doc:desc>
	</doc:doc>
	<xsl:template match="/app[view/data/century] | /app[view/data/entities/century]" mode="html.header.style">
		<link href="{$normalised-path-to-css}century.css" type="text/css" rel="stylesheet" /> 
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Centuries Index: initial template for creating the HTML body.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/entities/century]" mode="html.body">
		<xsl:apply-templates select="data/entities[century]" />		
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Century Profile: initial template for creating the HTML body.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/century]" mode="html.body">
		<xsl:apply-templates select="data/century"/>
	</xsl:template>
	
	
	
	
	<doc:doc>
		<doc:title>Page Title: Centuries index</doc:title>
		<doc:desc>
			<doc:p>The content to go in the page title of the index page for century entities.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/entities/event]" mode="view.title">
		<xsl:text>Events</xsl:text>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Page Title: Century entity profile page</doc:title>
		<doc:desc>
			<doc:p>Ensures that the content of the page title of an century entity profile page is a plain string.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/century]" mode="view.title">
		<xsl:variable name="title">
			<xsl:apply-templates select="data/century" mode="title" />
		</xsl:variable>
		
		<xsl:value-of select="xs:string($title)"/>
	</xsl:template>
	
	
	
	<doc:doc>
		<doc:title>Page Title: Century entity profile page</doc:title>
		<doc:note>
			<doc:p>Used for page title and hyperlinks to events.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="century" mode="title">
		<xsl:choose>
			<xsl:when test="not(@start)"><xsl:text>Date Unknown</xsl:text></xsl:when>
			<xsl:otherwise>
				<xsl:variable name="century" select="substring-after(@id, 'CEN')" as="xs:string" />
				<xsl:value-of select="fn:ordinal-number-en(xs:integer($century))" />
				<xsl:text> Century</xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Centuries Index</doc:title>
		<doc:desc>
			<doc:p>Lists all the centuries.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="data/entities[century]">
		<ul>
			<xsl:for-each select="century">
				<xsl:sort select="@start" data-type="number" order="ascending" />
				<li><xsl:apply-templates select="self::century" mode="href-html" /></li>
			</xsl:for-each>
		</ul>		
	</xsl:template>
	

	<doc:doc>
		<doc:title>Century Profile: layout template.</doc:title>
		<doc:desc>
			<doc:p>Creates a timeline of all the events in this century.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="data/century">
		<div class="body-matter">	
			<div class="timeline">
				<xsl:apply-templates select="self::century" mode="timeline" />
			</div>		
		</div>
	</xsl:template>
	

	<doc:doc>
		<doc:title>Hyperlink: Century</doc:title>
		<doc:desc>
			<doc:p>Generates a hyperlink to a century.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="century" mode="href-html">
		<xsl:param name="content" as="item()?" />
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('century/', @id)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:variable name="title">
					<xsl:apply-templates select="self::*" mode="title"/>
				</xsl:variable>
				<xsl:value-of select="xs:string($title)" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
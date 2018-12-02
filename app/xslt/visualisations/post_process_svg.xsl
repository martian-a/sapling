<xsl:stylesheet 	
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	xmlns:xlink="http://www.w3.org/1999/xlink"
	exclude-result-prefixes="#all" 
	version="2.0">		
	
	<xsl:param name="path-to-css" select="'../../../../../../css/'" />
	
	
	<xsl:template match="/">		
		<xsl:apply-templates />		
	</xsl:template>
	
	
	<xsl:template match="svg:svg/*[1]" priority="10">
		<svg:defs>
			<svg:style type="text/css">
				<xsl:text>@import url('</xsl:text><xsl:value-of select="$path-to-css" /><xsl:text>global.css');</xsl:text>
				<xsl:text>
				.node .text {
					font-family: 'fell';
				}
				</xsl:text>
			</svg:style>
		</svg:defs>
		<xsl:next-match />		
	</xsl:template>
	
	
	<xsl:template match="svg:text[ancestor::svg:g/@class = 'node']">
		<xsl:copy>
			<xsl:choose>
				<xsl:when test="@class">
					<xsl:attribute name="class"><xsl:value-of select="string-join((@class, 'text'), ' ')" /></xsl:attribute>
				</xsl:when>
				<xsl:otherwise>
					<xsl:attribute name="class">text</xsl:attribute>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="@*[name() != 'class'], node()" />
		</xsl:copy>
	</xsl:template>
	
	<!-- Graph Title -->
	<xsl:template match="svg:g[@class = 'graph']/svg:title/text()">
		<xsl:text>Family Tree</xsl:text>
	</xsl:template>
	
	<!-- Node Title -->
	<xsl:template match="svg:g[@class = 'node'][descendant::svg:text]/svg:title/text()">
		<xsl:call-template name="node-title" />
	</xsl:template>
	
	<!-- Node Hyperlink Title -->
	<xsl:template match="svg:a[ancestor::svg:g[@class = 'node'][descendant::svg:text]]/@xlink:title">
		<xsl:attribute name="xlink:title"><xsl:call-template name="node-title" /></xsl:attribute>
	</xsl:template>
	
	<xsl:template name="node-title">
		<xsl:for-each select="ancestor::svg:g[1]">
			<xsl:choose>
				<xsl:when test="descendant::svg:a/@xlink:href/contains(., '/person/')">
					<xsl:value-of select="descendant::svg:text[not(contains(lower-case(@font-family), 'dejavu sans mono'))][1]" />
					<xsl:if test="count(descendant::svg:text) > 1">
						<xsl:text> (</xsl:text>
						<xsl:value-of select="string-join(descendant::svg:text[position() > 1], ' ')" />
						<xsl:text>)</xsl:text>
					</xsl:if>	
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="string-join(descendant::svg:text, ' ')" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>


	<xsl:template match="element()">
		<xsl:copy><xsl:apply-templates select="attribute(), node()" /></xsl:copy>
	</xsl:template>	
	
	<xsl:template match="processing-instruction() | comment() | attribute() | text()">
		<xsl:copy><xsl:apply-templates select="node()" /></xsl:copy>
	</xsl:template>
	
</xsl:stylesheet>
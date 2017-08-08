<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:template match="/app[view/data/entities/location] | /app[view/data/location]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/location]" mode="html.body">
		<xsl:apply-templates select="data/entities[location]"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/location]" mode="html.body">
		<xsl:apply-templates select="data/location"/>
	</xsl:template>
	
	
	
	<xsl:template match="/app/view[data/entities/location]" mode="view.title">
		<xsl:text>location</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/location]" mode="view.title">
		<xsl:value-of select="xs:string(data/location/title)"/>
	</xsl:template>
	
	
	<xsl:template match="data/entities[location]">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	

	<xsl:template match="location/title"/>
	

	<xsl:template match="entities/location">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="location" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('location/', @ref)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="title" mode="href-html"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:template match="/app[view/data/entities/event] | /app[view/data/event]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/event]" mode="html.body">
		<xsl:apply-templates select="data/entities[event]"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/event]" mode="html.body">
		<xsl:apply-templates select="data/event"/>
	</xsl:template>
	
	
	
	<xsl:template match="/app/view[data/entities/event]" mode="view.title">
		<xsl:text>Events</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/event]" mode="view.title">
		<xsl:value-of select="xs:string(data/event/summary)"/>
	</xsl:template>
	
	
	<xsl:template match="data/entities[event]">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	

	<xsl:template match="event/summary"/>
	

	<xsl:template match="entities/event">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="event" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('event/', @ref)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="summary" mode="href-html"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
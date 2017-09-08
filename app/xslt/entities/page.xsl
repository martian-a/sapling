<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	
	<xsl:key name="page" match="data/page | related/page | entities/page" use="@id"/>
	
	<xsl:template match="/app[view/data/page]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	

	<xsl:template match="/app/view[data/page]" mode="view.title">
		<xsl:value-of select="xs:string(data/page/title)"/>
	</xsl:template>
	

	<xsl:template match="/app/view[data/page]" mode="html.body">
		<xsl:apply-templates select="data/page" />
	</xsl:template>


	<xsl:template match="data/page">
		<xsl:apply-templates select="body/node()" />
	</xsl:template>
		
			
	<xsl:template match="element()[ancestor::page/parent::data]">
		<xsl:copy><xsl:apply-templates select="attribute(), node()" /></xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="attribute()[ancestor::page/parent::data] | text()[ancestor::page/parent::data]">
		<xsl:copy><xsl:apply-templates select="node()" /></xsl:copy>
	</xsl:template>
					
	
	<xsl:template match="page[@ref]">
		<xsl:apply-templates select="key('page', @ref)" mode="href-html" />
	</xsl:template>
	
	<xsl:template match="page" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('page/', @id)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="title" mode="href-html"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
</xsl:stylesheet>
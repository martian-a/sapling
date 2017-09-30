<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	
	<xsl:key name="content" match="data/content | related/content | entities/content" use="@id"/>
		
	<xsl:template match="/app[view/data/content]" mode="html.header html.header.scripts html.header.style html.footer.scripts">
		<xsl:apply-templates select="view/data/content" mode="#current"/>
	</xsl:template>
	
	<xsl:template match="/app/view/data/content[@id = 'home']" mode="html.header.style" priority="10">
		<link type="text/css" href="{$normalised-path-to-css}home.css" rel="stylesheet"/>
	</xsl:template>
	
	<xsl:template match="/app/view/data/content" mode="html.header html.header.scripts html.header.style html.footer.scripts">
		
	</xsl:template>

	<xsl:template match="/app/view[data/content]" mode="view.title">
		<xsl:value-of select="xs:string(title)"/>
	</xsl:template>
	

	<xsl:template match="/app/view[data/content]" mode="html.body">
		<xsl:apply-templates select="data/content"/>
	</xsl:template>


	<xsl:template match="data/content">
		<xsl:apply-templates select="body/node()"/>
	</xsl:template>
		
			
	<xsl:template match="element()[not(@ref)][ancestor::content/parent::data]">
		<xsl:copy>
            <xsl:apply-templates select="attribute(), node()"/>
        </xsl:copy>
	</xsl:template>
	
	
	<xsl:template match="attribute()[ancestor::content/parent::data] | text()[ancestor::content/parent::data]">
		<xsl:copy>
            <xsl:apply-templates select="node()"/>
        </xsl:copy>
	</xsl:template>
					
	
	<xsl:template match="content[@ref]">
		<xsl:apply-templates select="key('content', @ref)" mode="href-html"/>
	</xsl:template>
	
	<xsl:template match="content" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('content/', @id)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="title" mode="href-html"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
</xsl:stylesheet>
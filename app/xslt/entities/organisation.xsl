<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<xsl:key name="organisation" match="related/organisation" use="@id" />
	
	
	<xsl:template match="/app[view/data/entities/organisation] | /app[view/data/organisation]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/organisation]" mode="html.body">
		<xsl:apply-templates select="data/entities[organisation]"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/organisation]" mode="html.body">
		<xsl:apply-templates select="data/organisation"/>
	</xsl:template>
	
	
	
	<xsl:template match="/app/view[data/entities/organisation]" mode="view.title">
		<xsl:text>organisations</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/organisation]" mode="view.title">
		<xsl:value-of select="xs:string(data/organisation/name)"/>
	</xsl:template>
	
	
	<xsl:template match="data/entities[organisation]">
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
		

	<xsl:template match="entities/organisation">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="organisation[@ref]">
		<xsl:apply-templates select="key('organisation', @ref)" mode="href-html" />
	</xsl:template>
	
	<xsl:template match="organisation" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('organisation/', @id)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="name" mode="href-html"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
</xsl:stylesheet>
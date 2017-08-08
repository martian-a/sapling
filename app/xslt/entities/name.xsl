<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:name="http://ns.kaikoda.com/nameumentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:template match="/app[view/data/entities/name] | /app[view/data/name]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/name]" mode="html.body">
		<xsl:apply-templates select="data/entities[name]"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/name]" mode="html.body">
		<xsl:apply-templates select="self::name[person]" mode="list.names.people" />
		<xsl:apply-templates select="self::name[location]" mode="list.names.locations" />
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/entities/name]" mode="view.title">
		<xsl:text>Names</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/name]" mode="view.title">
		<xsl:apply-templates select="data/name/name"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view/data/name">
		<xsl:value-of select="."/>
	</xsl:template>
	
	
	<xsl:template match="data/entities[name]">
		<ul>
			<xsl:apply-templates>
				<xsl:sort select="@ref" data-type="text" order="ascending"/>
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	
	<xsl:template match="entities/name">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="name[@ref]" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('name/', encode-for-uri(@ref))" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="text()" mode="href-html"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:name="http://ns.kaikoda.com/nameumentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:key name="name" match="data/name | related/name | entities/name" use="@id"/>
	
	<xsl:template match="/app[view/data/entities/name] | /app[view/data/name]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/name]" mode="html.body">
		<xsl:apply-templates select="data/entities[name]"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/name]" mode="html.body">
		<xsl:apply-templates />
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/entities/name]" mode="view.title">
		<xsl:text>Names</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/name]" mode="view.title">
		<xsl:apply-templates select="data/name/name"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view/data/name">
		<xsl:apply-templates select="derived-from[person]" mode="people" /> 
		<xsl:apply-templates select="derived-from[organisation]" mode="organisations" /> 
		<xsl:apply-templates select="derived-from[location]" mode="map" />
	</xsl:template>
	
	<xsl:template match="derived-from/person">
		
	</xsl:template>
	
	
	<xsl:template match="data/entities[name]">
		<div class="alphabetical">
			<h2>Alphabetical</h2>
			<div class="multi-column">
				<xsl:for-each-group select="name" group-by="@key/substring(translate(., '_', ' '), 1, 1)">
					<xsl:sort select="@key" data-type="text" order="ascending"/>
					<xsl:if test="current-grouping-key() != ' '">
						<div>
			<h3>
				<xsl:value-of select="current-grouping-key()"/>
			</h3>
		<ul>
								<xsl:apply-templates select="current-group()"/>
							</ul>
						</div>
	</xsl:if>
				</xsl:for-each-group>
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template match="entities/name">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="name[@id]" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('name/', encode-for-uri(@id))" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="name" mode="href-html"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
</xsl:stylesheet>
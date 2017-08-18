<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:template match="/app[view/data/indices]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/indices]" mode="html.body">
		<xsl:apply-templates select="/app/views" mode="nav.site"/>
	</xsl:template>
	
	<xsl:template match="/app/view[data/indices]" mode="html.body.title" priority="150"/>
	
	<xsl:template match="/app/view[data/indices]" mode="view.title"/>

	<!--
	<xsl:template match="data/indices">
		<ul>
			<xsl:for-each select="index">
				<li>
					<xsl:call-template name="href-html">
						<xsl:with-param name="path" select="@path" as="xs:string?"/>
						<xsl:with-param name="content" as="item()">
							<xsl:apply-templates select="title"/>
						</xsl:with-param>
					</xsl:call-template>						
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>
	-->
</xsl:stylesheet>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:key name="organisation" match="related/organisation | data/organisation | entities/organisation" use="@id" />
	
	
	<xsl:template match="/app[view/data/entities/organisation] | /app[view/data/organisation]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/organisation]" mode="html.body">
		<xsl:apply-templates select="data/entities[organisation]"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/organisation]" mode="html.body">
		<xsl:apply-templates select="data/organisation"/>
	</xsl:template>
	
	
	<xsl:template match="data/organisation">
		<xsl:apply-templates select="related[person]" mode="people" />
		<xsl:apply-templates select="related[organisation]" mode="organisations" />
		<xsl:apply-templates select="related[location]" mode="map" />
		<xsl:apply-templates select="related[event]" mode="timeline" />
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/entities/organisation]" mode="view.title">
		<xsl:text>Organisations</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/organisation]" mode="view.title">
		<xsl:value-of select="xs:string(data/organisation/name)"/>
	</xsl:template>
	
	
	<xsl:template match="data/entities[organisation]">
		<div class="nav-index alphabetical" id="nav-alpha">
			<h2>By Name</h2>
			
			<xsl:variable name="entries" as="element()*">
				<xsl:for-each-group select="organisation" group-by="upper-case(substring(lower-case(name), 1, 1))">
					<xsl:sort select="name" data-type="text" order="ascending" />
					<xsl:call-template name="generate-jump-navigation-group">
						<xsl:with-param name="group" select="current-group()" as="element()*" />
						<xsl:with-param name="key" select="current-grouping-key()" as="xs:string" />
						<xsl:with-param name="misc-match-test" select="''" as="xs:string" />
						<xsl:with-param name="misc-match-label" select="'Name Unknown'" as="xs:string" />
					</xsl:call-template>	
				</xsl:for-each-group>
			</xsl:variable>
			
			<xsl:call-template name="generate-jump-navigation">
				<xsl:with-param name="entries" select="$entries" as="element()*" />
				<xsl:with-param name="id" select="'nav-alpha'" as="xs:string" />
			</xsl:call-template>
			
		</div>
	</xsl:template>
		

	<xsl:template match="entities/organisation | group/entries/organisation">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="related" mode="organisations" priority="10">
		<xsl:next-match>
			<xsl:with-param name="organisations" select="organisation" as="element()*" />
		</xsl:next-match>
	</xsl:template>
	
	<xsl:template match="derived-from" mode="organisations" priority="10">
		<xsl:next-match>
			<xsl:with-param name="organisations" select="organisation/key('organisation', @ref)" as="element()*" />
		</xsl:next-match>
	</xsl:template>
	
	<doc:doc>
		<doc:title>Organisations</doc:title>
		<doc:desc>
			<doc:p>All organisations associated with an entity.</doc:p>
		</doc:desc>
		<doc:note>
			<doc:p>In alphabetical order.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="related | derived-from" mode="organisations">
		<xsl:param name="organisations" as="element()*" />
		
		<div class="organisations">
			<h2>Organisations</h2>
			<ul>
				<xsl:for-each select="$organisations">
					<xsl:sort select="name" data-type="text" order="ascending" />
					<li><xsl:apply-templates select="self::*" mode="href-html" /></li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	
	
	<xsl:template match="organisation[@ref]">
		<xsl:apply-templates select="key('organisation', @ref)" mode="href-html" />
	</xsl:template>
	
	<xsl:template match="organisation" mode="href-html">
		<xsl:param name="inline-value" as="xs:string?" tunnel="yes" />
		
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('organisation/', @id)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:choose>
					<xsl:when test="$inline-value != ''">
						<xsl:value-of select="$inline-value" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="name" mode="href-html"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
</xsl:stylesheet>
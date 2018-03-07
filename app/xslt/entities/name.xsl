<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:key name="name" match="data/name | related/name | entities/name" use="@id"/>
	
	<!-- xsl:template match="/app[view/data/entities/name] | /app[view/data/name]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/ -->
	
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
		<xsl:apply-templates select="derived-from[location]" mode="locations" />
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>Filter related locations to only those that are either directly referenced from the person or from events related to the person.</doc:desc>
		<doc:note>
			<doc:p>Otherwise the list includes locations that are in the related list purely to provide context for the truly related locations.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="app/view[data/name/related/location]" mode="html.body html.footer.scripts" priority="1000">
		<xsl:variable name="directly-referenced-locations" select="data/name/related/location[@id = ancestor::name/note/descendant::location/@ref]" as="element()*" />        
		<xsl:variable name="locations-referenced-from-events" select="data/name/related/location[@id = ancestor::related/event/descendant::location/@ref]" as="element()*" />
		
		<xsl:if test="count(($directly-referenced-locations | $locations-referenced-from-events)) &gt; 0">
			<xsl:next-match>
				<xsl:with-param name="locations" select="$directly-referenced-locations | $locations-referenced-from-events" as="element()*" tunnel="yes" />
			</xsl:next-match>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="derived-from/person" />
		
	
	
	
	<doc:doc>
		<doc:title>Names Index</doc:title>
		<doc:desc>
			<doc:ul>
				<doc:ingress>Lists all name entities:</doc:ingress>
				<doc:li>in alphabetical order</doc:li>
			</doc:ul>
		</doc:desc>
	</doc:doc>
	<xsl:template match="data/entities[name]">
		<div class="contents">
			<p>An index of individual name parts belonging to people, locations and organisations on this site.</p>
		</div>
		<div class="nav-index alphabetical" id="nav-alpha">
			<h2>Alphabetical</h2>
			
			<xsl:variable name="entries" as="element()*">
				<xsl:call-template name="generate-jump-navigation-group">
					<xsl:with-param name="group" select="name[string-length(.) = 1]" as="element()*" />
					<xsl:with-param name="key" select="'1'" as="xs:string" />
					<xsl:with-param name="misc-match-test" select="'1'" as="xs:string" />
					<xsl:with-param name="misc-match-label" select="'Initials'" as="xs:string" />
				</xsl:call-template>	
				<xsl:for-each-group select="name[string-length(.) &gt; 1]" group-by="upper-case(@key/substring(translate(., '_', ' '), 1, 1))">
					<xsl:sort select="@key" data-type="text" order="ascending"/>
					<xsl:call-template name="generate-jump-navigation-group">
						<xsl:with-param name="group" select="current-group()" as="element()*" />
						<xsl:with-param name="key" select="current-grouping-key()" as="xs:string" />
						<xsl:with-param name="misc-match-test" select="' '" as="xs:string" />
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
	
	
	<xsl:template match="entities/name | group/entries/name">
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
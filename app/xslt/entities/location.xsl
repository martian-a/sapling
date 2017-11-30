<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:key name="location" match="data/location | related/location | entities/location" use="@id" />
	<xsl:key name="location-within" match="data/location | related/location" use="within/@ref" />
	
	<xsl:template match="/app[view/data/entities/location] | /app[view/data/location]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/location]" mode="html.body">
		<xsl:apply-templates select="data/entities[location]"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/location]" mode="html.body">
		<xsl:apply-templates select="data/location" />		
	</xsl:template>
	
	<xsl:template match="data/location">
		<xsl:apply-templates select="@type"/>
		<xsl:apply-templates select="self::*[related/location]" mode="context" />		
		<xsl:apply-templates select="self::*[note]" mode="notes" /> 
		<xsl:apply-templates select="related[event]" mode="timeline" /> 
		<xsl:apply-templates select="related[person]" mode="people" />
		<xsl:apply-templates select="related[organisation]" mode="organisations" />
	</xsl:template>
	
	<xsl:template match="data/location/@type">
		<p class="type"><xsl:value-of select="." /></p>
	</xsl:template>
	
	
	<xsl:template match="data/location" mode="context">
		<xsl:variable name="full-context" select="fn:get-full-location-context(self::location)" as="element()*" />
		<xsl:variable name="locations-within" select="fn:get-locations-within(self::location)" as="element()*" />
		
		<xsl:if test="(count($full-context) + count($locations-within)) > 0">
			<div class="context">
				<h2>Context</h2>
				<xsl:if test="count($full-context) > 0">
					<h3>Within</h3>
					<ul>
						<xsl:apply-templates select="$full-context" mode="context" />
					</ul>
				</xsl:if>
				<xsl:if test="count($locations-within) > 0">
					<h3>Contains</h3>
					<xsl:call-template name="locations-within">
						<xsl:with-param name="locations" select="$locations-within" as="element()*" />
					</xsl:call-template>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="locations-within">
		<xsl:param name="locations" as="element()*" />
		<ul>
			<xsl:for-each select="$locations">
				<xsl:sort select="name[1]" data-type="text" order="ascending" />
				<xsl:apply-templates select="current()" mode="context" />
				<xsl:variable name="locations-within" select="fn:get-locations-within(current())" as="element()*" />
				<xsl:if test="count($locations-within) > 0">
					<xsl:call-template name="locations-within">
						<xsl:with-param name="locations" select="$locations-within" as="element()*" />
					</xsl:call-template>
				</xsl:if>
			</xsl:for-each>
		</ul>
	</xsl:template>
	
	<xsl:template match="related/location" mode="context">
		<li><xsl:apply-templates select="self::*" mode="href-html" /></li>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/entities/location]" mode="view.title">
		<xsl:text>Locations</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/location]" mode="view.title">
		<xsl:value-of select="xs:string(data/location/name[1])"/>
	</xsl:template>
	
	
	<xsl:template match="data/entities[location]">
		<div class="contents">
			<p>Browse by:</p>
			<ul>
				<li><a href="#nav-alpha">Name</a></li>
				<li><a href="#nav-country">Country</a></li>
			</ul>
		</div>
		<div class="nav-index alphabetical" id="nav-alpha">
			<h2>By Name
				<xsl:text> </xsl:text>
				<a href="#top" class="nav" title="Top of page">▴</a></h2>
			
			<xsl:variable name="entries" as="element()*">
				<xsl:for-each-group select="fn:sort-locations(location)" group-by="upper-case(substring(fn:get-location-sort-name(self::location), 1, 1))">
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
		
		<div class="nav-index alphabetical" id="nav-country">
			<h2>By Country
				<xsl:text> </xsl:text>
				<a href="#top" class="nav" title="Top of page">▴</a></h2>
			
			<xsl:variable name="entries" as="element()*">
				<xsl:for-each-group select="fn:sort-locations(location)" group-by="fn:get-location-context(self::location)[@type = 'continent']">
					<xsl:sort select="current-grouping-key()" data-type="text" order="ascending" />
					<xsl:call-template name="generate-jump-navigation-group">
						<xsl:with-param name="group" select="current-group()" as="element()*" />						<xsl:with-param name="key" select="current-grouping-key()" as="xs:string" />
						<xsl:with-param name="misc-match-test" select="''" as="xs:string" />
						<xsl:with-param name="misc-match-label" select="'Continent Unknown'" as="xs:string" />
					</xsl:call-template>	
				</xsl:for-each-group>
			</xsl:variable>
			
			<xsl:call-template name="generate-jump-navigation">
				<xsl:with-param name="entries" select="$entries" as="element()*" />
				<xsl:with-param name="id" select="'nav-country'" as="xs:string" />
				<xsl:with-param name="base" select="('Antarctica', 'Africa', 'Asia', 'Europe', 'North America', 'Oceania', 'South America')" as="xs:string*" />
			</xsl:call-template>
			
		</div>
	</xsl:template>
	

	<xsl:template match="related/location">
		<xsl:apply-templates select="self::*" mode="in-context" />
	</xsl:template>


	<xsl:template match="location" mode="in-context">
		<xsl:apply-templates select="self::*" mode="href-html" />
		<xsl:variable name="context" select="fn:get-location-context(self::*)" as="element()*" />
		<xsl:for-each select="$context">
			<xsl:text>, </xsl:text>				
			<xsl:apply-templates select="/*/key('location', current()/@id)" mode="href-html" />
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="location/name"/>
	

	<xsl:template match="entities/location | group/entries/location">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="location[@ref][not(ancestor::event)]">
		<xsl:apply-templates select="key('location', @ref)" />
	</xsl:template>
	
	
	<xsl:template match="location[@ref][ancestor::event]">
		<xsl:apply-templates select="key('location', @ref)" mode="in-context" />
	</xsl:template>
	
	<xsl:template match="data/location" mode="href-html">
		<span class="self-reference"><xsl:apply-templates select="name[1]" mode="href-html"/></span>
	</xsl:template>
	
	<xsl:template match="related/location | entities/location | group/entries/location" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('location/', @id)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="name[1]" mode="href-html"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	<xsl:template match="related" mode="map" priority="10">
		<xsl:variable name="events" select="if (parent::event) then parent::event else event" as="element()*" />
		
		<xsl:next-match>
			<xsl:with-param name="locations" select="$events/descendant::location[not(ancestor::related/parent::event)]/key('location', @ref)" as="element()*" />
		</xsl:next-match>
	</xsl:template>
	
	<xsl:template match="derived-from" mode="map" priority="10">		
		<xsl:next-match>
			<xsl:with-param name="locations" select="location/key('location', @ref)" as="element()*" />
		</xsl:next-match>
	</xsl:template>
	
	
	
	
	<xsl:template match="related | derived-from" mode="map">
		<xsl:param name="locations" as="element()*" />
		
		<xsl:if test="count($locations) > 0">
			<div class="locations">
				<h2>Locations</h2>
				<ul>
					<xsl:for-each select="$locations">
						<li><xsl:apply-templates select="self::*" /></li>
					</xsl:for-each>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
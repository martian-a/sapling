<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<xsl:key name="location" match="data/location | related/location | entities/location" use="@id" />
	<xsl:key name="location-within" match="data/location | related/location" use="within/@ref" />
	
	<xsl:template match="/app[view/data/entities/location] | /app[view/data/location]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	
	<xsl:template match="/app[view/data/location]" mode="html.footer.scripts" priority="10">
		<script src="{$normalised-path-to-js}maps.js"><xsl:comment>Leaflet (maps)</xsl:comment></script>
		<xsl:apply-templates select="view/data/location/geo:point" mode="#current" />
		<xsl:next-match />
	</xsl:template>
	
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
		<xsl:variable name="locations-within" select="fn:get-locations-within(self::location, 1)" as="element()*" />
		
		<xsl:apply-templates select="geo:point" />		
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
					<xsl:apply-templates select="self::location" mode="locations-within">
						<xsl:with-param name="locations-within" select="$locations-within" as="element()*" />
					</xsl:apply-templates>
				</xsl:if>
			</div>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="data/location/geo:point" priority="100" mode="#all">
		<xsl:next-match>
			<xsl:with-param name="map-id" select="concat('map-', parent::location/(@id | @ref))" as="xs:string" />
		</xsl:next-match>
	</xsl:template>
	
	
	<xsl:template match="data/location/geo:point">		
		<xsl:param name="map-id" as="xs:string" />
		<div id="{$map-id}" style="height:250px;"><xsl:comment>Leaflet (maps)</xsl:comment></div>
	</xsl:template>
	
	<xsl:template match="data/location/geo:point" mode="html.footer.scripts">
		<xsl:param name="map-id" as="xs:string" />
		
		<script>
			<xsl:text>map('</xsl:text><xsl:value-of select="$map-id" /><xsl:text>', </xsl:text>
			<xsl:value-of select="@geo:lat" />
			<xsl:text>, </xsl:text>
			<xsl:value-of select="@geo:long" />
			<xsl:text>, </xsl:text>
			<xsl:choose>
				<xsl:when test="@zoom"><xsl:value-of select="@zoom" /></xsl:when>
				<xsl:when test="parent::location/@type = 'continent'">3</xsl:when>
				<xsl:when test="parent::location/@type = 'country'">5</xsl:when>
				<xsl:when test="parent::location/@type = 'settlement'">10</xsl:when>
				<xsl:otherwise>8</xsl:otherwise>
			</xsl:choose>
			<xsl:text>,</xsl:text>
			<xsl:text>[</xsl:text>
			<xsl:text>[</xsl:text><xsl:value-of select="@geo:lat" /><xsl:text>,</xsl:text><xsl:value-of select="@geo:long" /><xsl:text>]</xsl:text>
			<xsl:text>]</xsl:text>
			<xsl:text>);</xsl:text>
		</script>
	</xsl:template>
	
	
	<xsl:template match="location" mode="locations-within">
		<xsl:param name="locations-within" select="fn:get-locations-within(self::location, 1)" as="element()*" />
		
		<xsl:if test="count($locations-within) &gt; 0">
			<ul>
				<xsl:for-each select="$locations-within">
					<xsl:sort select="name[1]" data-type="text" order="ascending" />
					<li>
						<p><xsl:apply-templates select="self::*" mode="href-html" /></p>
						<xsl:apply-templates select="self::location" mode="locations-within" />	
					</li>
				</xsl:for-each>
			</ul>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="related/location" mode="context">
		<li><xsl:apply-templates select="self::*" mode="href-html" /></li>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/entities/location]" mode="view.title">
		<xsl:text>Locations</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/location]" mode="view.title">
		<xsl:choose>
			<xsl:when test="data/location/@type = 'building-number'">
				<xsl:value-of select="concat(xs:string(data/location/name[1]), ' ', key('location', data/location/within[not(@rel = 'political')][1]/@ref)/xs:string(name[1]))"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="xs:string(data/location/name[1])"/>
			</xsl:otherwise>
		</xsl:choose>
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
				<xsl:for-each-group select="fn:sort-locations(location[not(@type = 'building-number')])" group-by="upper-case(substring(fn:get-location-sort-name(self::location), 1, 1))">
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
				<xsl:for-each-group select="fn:sort-locations(location[@type = 'country'])" group-by="fn:get-location-context(self::location)[@type = 'continent']">
					<xsl:sort select="current-grouping-key()" data-type="text" order="ascending" />
					<xsl:call-template name="generate-jump-navigation-group">
						<xsl:with-param name="group" select="current-group()" as="element()*" />						
						<xsl:with-param name="key" select="current-grouping-key()" as="xs:string" />
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
	

	<!-- Entry in related locations list. -->
	<xsl:template match="related/location">
		<xsl:param name="inline-label" as="xs:string?" tunnel="yes" />
		
		<xsl:choose>
			<xsl:when test="$inline-label != ''">
				<xsl:apply-templates select="self::*" mode="without-context" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="self::*" mode="in-context" />	
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<xsl:template match="location" mode="without-context">
		<xsl:param name="inline-label" as="xs:string?" tunnel="yes" />
		
		<xsl:apply-templates select="self::*" mode="href-html" />
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
	
	
	<!-- Reference to a location in a note or event summary. -->
	<xsl:template match="location[@ref]">
		<xsl:param name="inline-value" as="xs:string?" tunnel="yes"/>
		<xsl:variable name="location" select="key('location', @ref)" as="element()" />
		
		<xsl:choose>
			<xsl:when test="$inline-value != ''">
				<xsl:apply-templates select="$location" mode="without-context" />
			</xsl:when>
			<xsl:when test="$location[@type = ('country', 'continent')]">
				<xsl:apply-templates select="$location" mode="without-context" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="$location" mode="in-context" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<xsl:template match="data/location" mode="href-html">
		<span class="self-reference"><xsl:apply-templates select="name[1]" mode="href-html"/></span>
	</xsl:template>
	
	
	<xsl:template match="related/location | entities/location | group/entries/location" mode="href-html">
		<xsl:param name="inline-value" as="xs:string?" tunnel="yes" />
		
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('location/', @id)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:choose>
					<xsl:when test="$inline-value != ''">
						<xsl:value-of select="$inline-value" />
					</xsl:when>
					<xsl:otherwise>
						<xsl:apply-templates select="name[1]" mode="href-html"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	<xsl:template match="related[location]" mode="map html.footer.scripts" priority="10">
		<xsl:variable name="events" select="if (parent::event) then parent::event else event" as="element()*" />
		
		<xsl:next-match>
			<xsl:with-param name="locations" select="fn:sort-locations($events/descendant::location[not(ancestor::related/parent::event)]/key('location', @ref))" as="element()*" />
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
				
				<xsl:if test="self::related and $locations[geo:point]">
					<script>
						<xsl:text>var </xsl:text><xsl:value-of select="concat('map', ancestor::data/*/@id, 'LocationsMarkers')" /><xsl:text> = [</xsl:text>
						<xsl:for-each select="$locations/geo:point">
							<xsl:text>[</xsl:text><xsl:value-of select="@geo:lat" /><xsl:text>,</xsl:text><xsl:value-of select="@geo:long" /><xsl:text>, "</xsl:text><xsl:value-of select="parent::location/name[1]" /><xsl:text>"]</xsl:text><xsl:if test="position() != last()">,</xsl:if>
						</xsl:for-each>
						<xsl:text>];</xsl:text>
					</script>
					<div id="map-{ancestor::data/*/@id}-locations" style="height:250px;" class="map"><xsl:comment>Leaflet (maps)</xsl:comment></div>
				</xsl:if>
				
				<ul>
					<xsl:if test="count($locations) > 6">
						<xsl:attribute name="class">multi-column</xsl:attribute>
					</xsl:if>
					<xsl:for-each select="$locations">
						<li><xsl:apply-templates select="self::*" /></li>
					</xsl:for-each>
				</ul>
				
			</div>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="related[location/geo:point]" mode="html.footer.scripts">
		<xsl:param name="locations" as="element()*" />
		<xsl:variable name="map-id" select="concat('map-', ancestor::data/*/@id, '-locations')" as="xs:string" />
		
		<xsl:variable name="map-focus" select="fn:get-map-focus($locations)" as="element()" />
		
		
		<script src="{$normalised-path-to-js}maps.js"><xsl:comment>Leaflet (maps)</xsl:comment></script>
		<script>
			<xsl:text>map('</xsl:text><xsl:value-of select="$map-id" /><xsl:text>', </xsl:text>
			<xsl:value-of select="$map-focus/@geo:lat" />
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$map-focus/@geo:long" />
			<xsl:text>, </xsl:text>
			<xsl:value-of select="$map-focus/@zoom" />
			<xsl:text>,</xsl:text>
			<xsl:value-of select="concat('map', ancestor::data/*/@id, 'LocationsMarkers')" />
			<xsl:text>);</xsl:text>
		</script>
	</xsl:template>
	
</xsl:stylesheet>
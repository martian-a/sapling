<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<xsl:key name="event" match="data/event | related/event | entities/event" use="@id" />
	
	<xsl:template match="/app[view/data/entities/event] | /app[view/data/event]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/event]" mode="html.body">
		<xsl:apply-templates select="data/entities[event]" />		
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/event]" mode="html.body">
		<xsl:apply-templates select="data/event"/>
	</xsl:template>
	
	<xsl:template match="data/event">
		<xsl:apply-templates select="self::*" mode="timeline" />
		<xsl:apply-templates select="related[person]" mode="people" />
		<xsl:apply-templates select="related[location]" mode="map" />
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/entities/event]" mode="view.title">
		<xsl:text>Events</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/event]" mode="view.title">
		<xsl:variable name="title">
			<xsl:apply-templates select="data/event" mode="title" />
		</xsl:variable>
		
		<xsl:value-of select="xs:string($title)"/>
	</xsl:template>
	
	<xsl:template match="event[summary]" mode="title">
		<xsl:apply-templates select="summary" />
	</xsl:template>
	
	
	<xsl:template match="event[not(summary)]" mode="title">
		<xsl:variable name="subjects" as="element()*">
			<xsl:choose>
				<xsl:when test="@type = 'marriage'">
					<xsl:sequence select="fn:sort-people(key('person', person/@ref))" />
				</xsl:when>
				<xsl:otherwise>
					<xsl:sequence select="fn:sort-people(person/key('person', @ref))" />
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:value-of select="fn:title-case(@type)" />
		<xsl:if test="count($subjects) > 0">
			<xsl:text> of </xsl:text>		
			<xsl:for-each select="$subjects">
				<xsl:apply-templates select="persona[1]/name" mode="href-html" />
				<xsl:choose>
					<xsl:when test="position() = last()" />
					<xsl:when test="position() = (last() - 1)"> and </xsl:when>
					<xsl:otherwise>, </xsl:otherwise>
				</xsl:choose>
			</xsl:for-each>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="data/entities[event]">
		<xsl:for-each-group select="event" group-by="@type">
			<xsl:sort select="current-grouping-key()" data-type="text" order="ascending" />
			<div class="{current-grouping-key()}">
				<h2>
					<xsl:choose>
						<xsl:when test="current-grouping-key() = 'historical'">
							<xsl:value-of select="fn:title-case(current-grouping-key())" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="concat(fn:title-case(current-grouping-key()), 's')" />
						</xsl:otherwise>
					</xsl:choose>
				</h2>
				<ul class="multi-column">
					<xsl:choose>
						<xsl:when test="@type = 'historical'">
							<xsl:apply-templates select="current-group()" mode="event.index">
								<xsl:sort select="date/@year" data-type="number" order="ascending" />
								<xsl:sort select="date/@month" data-type="number" order="ascending" />
								<xsl:sort select="date/@day" data-type="number" order="ascending" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="people" select="current-group()/person/key('person', @ref)" as="element()*" />
							<xsl:apply-templates select="fn:sort-people($people)" mode="event.index">
								<xsl:with-param name="events" select="current-group()" as="element()*" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>
				</ul>
			</div>
		</xsl:for-each-group>

	</xsl:template>
	

	<xsl:template match="event[@type = 'historical' or count(person) &lt; 2]" mode="event.index">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html" />
		</li>
	</xsl:template>
	
	<xsl:template match="person" mode="event.index">
		<xsl:param name="events" as="element()*" />
		<xsl:variable name="person" select="self::person" as="element()" />
		
		<xsl:for-each select="$events[person/@ref = $person/@id]">
			<li>
				<span class="person">
					<xsl:apply-templates select="self::event" mode="href-html">
						<xsl:with-param name="content">
							<xsl:apply-templates select="$person/persona/name" mode="href-html" />
						</xsl:with-param>
					</xsl:apply-templates>
					<xsl:apply-templates select="$person/persona/gender" mode="glyph" />
				</span>
			</li>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template match="event" mode="href-html">
		<xsl:param name="content" as="item()?" />
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('event/', @id)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:variable name="title">
					<xsl:choose>
						<xsl:when test="$content != ''">
							<xsl:copy-of select="$content" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="self::*" mode="title"/>
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:variable>
				<xsl:value-of select="xs:string($title)" />
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	
	
	<xsl:template match="event" mode="summarise" priority="100">
		<p class="summary"><xsl:next-match /></p>
	</xsl:template>
	
	
	<xsl:template match="event[summary]" mode="summarise">
		<xsl:apply-templates select="summary" />
	</xsl:template>
	
	<xsl:template match="event/summary">
		<xsl:apply-templates />
	</xsl:template>
	
	<xsl:template match="event[not(summary)]" mode="summarise" priority="50">
		<xsl:next-match />
		<xsl:if test="location">
			<xsl:text> in </xsl:text>
			<xsl:apply-templates select="key('location', location/@ref)" mode="href-html" />
		</xsl:if>
		<xsl:text>.</xsl:text>
	</xsl:template>
	
	<xsl:template match="event[@type = 'birth'][not(summary)]" mode="summarise">
		<xsl:variable name="parents" select="fn:sort-people(key('person', parent/@ref))" as="element()*" />
		
		<xsl:apply-templates select="key('person', person/@ref)" mode="href-html" />
		<xsl:text> is born</xsl:text>
		<xsl:if test="count($parents) > 0"> to </xsl:if>
		<xsl:for-each select="$parents">
			<xsl:apply-templates select="self::*" mode="href-html" />		
			<xsl:choose>
				<xsl:when test="position() = last()" />
				<xsl:when test="position() = (last() - 1)"> and </xsl:when>
				<xsl:otherwise>, </xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

	</xsl:template>
	
	<xsl:template match="event[@type = 'christening'][not(summary)]" mode="summarise">
		<xsl:apply-templates select="key('person', person/@ref)" mode="href-html" />
		<xsl:text> is christened</xsl:text>
	</xsl:template>
	
	<xsl:template match="event[@type = 'marriage'][not(summary)]" mode="summarise">
		<xsl:variable name="partners" select="fn:sort-people(key('person', person/@ref))" as="element()*" />
		
		<xsl:call-template name="punctuate-list-href-html">
			<xsl:with-param name="entries" select="$partners" as="element()*" />
		</xsl:call-template>
		<xsl:choose>
			<xsl:when test="count($partners) = 1"> marries.</xsl:when>
			<xsl:otherwise> marry</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	<xsl:template match="event[@type = 'death'][not(summary)]" mode="summarise">
	
		<xsl:apply-templates select="key('person', person/@ref)" mode="href-html" />
		<xsl:text> dies</xsl:text>
		
	</xsl:template>
	
	
	<xsl:template name="punctuate-list-href-html">
		<xsl:param name="entries" as="element()*" />
		
		<xsl:for-each select="$entries">
			<xsl:apply-templates select="self::*" mode="href-html" />
			<xsl:choose>
				<xsl:when test="position() = last()" />
				<xsl:when test="position() = (last() - 1)"> and </xsl:when>
				<xsl:otherwise>, </xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template match="event/date">
		<p class="date">
			<xsl:apply-templates select="@day" />
			<xsl:if test="@day and (@month or @year)">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="@month" />
			<xsl:if test="@month and @year">
				<xsl:text> </xsl:text>
			</xsl:if>
			<xsl:apply-templates select="@year" />
		</p>
	</xsl:template>
	
	<xsl:template match="event/date/@year">
		<span class="year">
			<xsl:value-of select="." />
		</span>
	</xsl:template>
	
	<xsl:template match="event/date/@month">
		<span class="month">
			<xsl:choose>
				<xsl:when test=". = 1">January</xsl:when>
				<xsl:when test=". = 2">February</xsl:when>
				<xsl:when test=". = 3">March</xsl:when>
				<xsl:when test=". = 4">April</xsl:when>
				<xsl:when test=". = 5">May</xsl:when>
				<xsl:when test=". = 6">June</xsl:when>
				<xsl:when test=". = 7">July</xsl:when>
				<xsl:when test=". = 8">August</xsl:when>
				<xsl:when test=". = 9">September</xsl:when>
				<xsl:when test=". = 10">October</xsl:when>
				<xsl:when test=". = 11">November</xsl:when>
				<xsl:when test=". = 12">December</xsl:when>
				<xsl:otherwise />
			</xsl:choose>
		</span>
	</xsl:template>
	
	<xsl:template match="event/date/@day">
		<span class="day">
			<xsl:value-of select="." />
		</span>
	</xsl:template>

	
</xsl:stylesheet>
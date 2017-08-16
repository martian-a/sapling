<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<xsl:template match="/app[view/data/entities/event] | /app[view/data/event]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/event]" mode="html.body">
		<xsl:apply-templates select="data/entities[event]"/>
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
	
	<xsl:template match="data/event[summary]" mode="title">
		<xsl:apply-templates select="summary" />
	</xsl:template>
	
	
	<xsl:template match="data/event[not(summary)]" mode="title">
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
		<ul>
			<xsl:apply-templates/>
		</ul>
	</xsl:template>
	

	<xsl:template match="entities/event">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="event" mode="href-html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="concat('event/', @ref)" as="xs:string"/>
			<xsl:with-param name="content" as="item()">
				<xsl:variable name="title">
					<xsl:apply-templates select="self::*" mode="title"/>	
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
<?xml-model href="http://ns.thecodeyard.co.uk/schema/cinnamon.sch?v=0.1.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
	
	<doc:doc>
		<doc:title>Key: Event</doc:title>
		<doc:desc>
			<doc:p>For quickly finding an event entity in the data, using it's ID.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="event" match="data/event | related/event | entities/event" use="@id" />
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>HTML Head: event (entity)-specific content that needs to go in the head of the HTML document.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app[view/data/entities/event] | /app[view/data/event]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Events Index: initial template for creating the HTML body.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/entities/event]" mode="html.body">
		<xsl:apply-templates select="data/entities[event]" />		
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Event Profile: initial template for creating the HTML body.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/event]" mode="html.body">
		<xsl:apply-templates select="data/event"/>
	</xsl:template>
	
	
	
	
	<doc:doc>
		<doc:title>Page Title: Events index</doc:title>
		<doc:desc>
			<doc:p>The content to go in the page title of the index page for event entities.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/entities/event]" mode="view.title">
		<xsl:text>Events</xsl:text>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Page Title: Event entity profile page</doc:title>
		<doc:desc>
			<doc:p>Ensures that the content of the page title of an event entity profile page is a plain string.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/event]" mode="view.title">
		<xsl:variable name="title">
			<xsl:apply-templates select="data/event" mode="title" />
		</xsl:variable>
		
		<xsl:value-of select="xs:string($title)"/>
	</xsl:template>
	
	
	
	<doc:doc>
		<doc:title>Page Title: Event entity profile page</doc:title>
		<doc:desc>
			<doc:p>Copies the existing prose summary.</doc:p>
		</doc:desc>
		<doc:note>
			<doc:p>Used for page title and hyperlinks to events.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="event[summary]" mode="title">
		<xsl:apply-templates select="summary" />
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Page Title: Event entity profile page</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for an event that doesn't already have one.</doc:p>
		</doc:desc>
		<doc:note>
			<doc:p>Used for page title and hyperlinks to events.</doc:p>
		</doc:note>
	</doc:doc>
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
	
	
	<doc:doc>
		<doc:title>Events Index</doc:title>
		<doc:desc>
			<doc:p>Creates a timeline of all events.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="data/entities[event]">
		<xsl:apply-templates select="self::*" mode="timeline" />
	</xsl:template>
	

	<doc:doc>
		<doc:title>Event Profile: layout template.</doc:title>
	</doc:doc>
	<xsl:template match="data/event">
		<xsl:apply-templates select="self::*" mode="timeline" />
		<xsl:apply-templates select="related[person]" mode="people" />
		<xsl:apply-templates select="related[location]" mode="locations" />
	</xsl:template>
	
	<!--
	<doc:doc>
		<doc:title>Events by Type</doc:title>
		<doc:desc>
			<doc:ul>
				<doc:ingress>Groups events by type and then generates a section for each group, composed of:</doc:ingress>
				<doc:li>event type (heading)</doc:li>
				<doc:li>a list of all the events in the the group</doc:li>
				<doc:egress>in chronological order.</doc:egress>
			</doc:ul>
		</doc:desc>
	</doc:doc>
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
	

	<doc:doc>
		<doc:title>Events by Type: Historical</doc:title>
		<doc:desc>
			<doc:p>List entry</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="event[@type = 'historical']" mode="event.index">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html" />
		</li>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Events by Type: Birth, Christening, Death</doc:title>
		<doc:desc>
			<doc:p>List entry</doc:p>
		</doc:desc>
	</doc:doc>
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
	-->
	
	
	<doc:doc>
		<doc:title>Event Summary (Wrapper)</doc:title>
		<doc:desc>
			<doc:p>Wraps an event summary in an appropriately classed paragraph.</doc:p>
		</doc:desc>
		<doc:note date="2017-08-27">
			<doc:p>As used in timelines.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="event" mode="summarise" priority="100">
		<p class="summary"><xsl:next-match /></p>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Event Summary (Content)</doc:title>
		<doc:desc>
			<doc:p>Copies an event's pre-existing summary, if it has one.</doc:p>
		</doc:desc>
		<doc:note date="2017-08-27">
			<doc:p>As used in timelines.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="event[summary]" mode="summarise">
		<xsl:apply-templates select="summary" />
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Event Summary (Content)</doc:title>
		<doc:desc>
			<doc:p>Copies an event's pre-existing summary, if it has one.</doc:p>
		</doc:desc>
		<doc:note date="2017-08-27">
			<doc:p>As used in timelines.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="event/summary">
		<xsl:apply-templates />
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Event Summary (Content)</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for an event that doesn't already have one.</doc:p>
		</doc:desc>
		<doc:note date="2017-08-27">
			<doc:p>As used in timelines.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="event[not(summary)]" mode="summarise" priority="50">
		<xsl:next-match />
		<xsl:if test="location">
			<xsl:variable name="event-location" select="key('location', location/@ref)" as="element()" />
			<xsl:choose>
				<xsl:when test="$event-location[@type = ('building-number', 'address')]">
					<xsl:text> at </xsl:text>
				</xsl:when>
				<xsl:otherwise>
					<xsl:text> in </xsl:text>
				</xsl:otherwise>
			</xsl:choose>
			<xsl:apply-templates select="$event-location" mode="in-context" />
		</xsl:if>
		<xsl:text>.</xsl:text>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Event Summary (Content): Birth</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for a birth.</doc:p>
		</doc:desc>
		<doc:note date="2017-08-27">
			<doc:p>As used in timelines.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="event[@type = 'birth'][not(summary)]" mode="summarise">
		<xsl:variable name="parents" select="fn:sort-people(key('person', parent/@ref))" as="element()*" />
		<xsl:variable name="child" select="key('person', person/@ref)" as="element()?" />
	
		<xsl:choose>
			<xsl:when test="count($child) &gt; 0">
				<xsl:apply-templates select="$child" mode="href-html" />
			</xsl:when>
			<xsl:otherwise>A child</xsl:otherwise>
		</xsl:choose>
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
	
	
	<doc:doc>
		<doc:title>Event Summary (Content): Christening</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for a christening.</doc:p>
		</doc:desc>
		<doc:note date="2017-08-27">
			<doc:p>As used in timelines.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="event[@type = 'christening'][not(summary)]" mode="summarise">
		<xsl:apply-templates select="key('person', person/@ref)" mode="href-html" />
		<xsl:text> is christened</xsl:text>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Event Summary (Content): Marriage</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for a marriage.</doc:p>
		</doc:desc>
		<doc:note date="2017-08-27">
			<doc:p>As used in timelines.</doc:p>
		</doc:note>
	</doc:doc>
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
	
	
	<doc:doc>
		<doc:title>Event Summary (Content): Death</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for a death.</doc:p>
		</doc:desc>
		<doc:note date="2017-08-27">
			<doc:p>As used in timelines.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="event[@type = 'death'][not(summary)]" mode="summarise">
	
		<xsl:apply-templates select="key('person', person/@ref)" mode="href-html" />
		<xsl:text> dies</xsl:text>
		
	</xsl:template>
	
	
	
	<doc:doc>
		<doc:title>Event Date</doc:title>
	</doc:doc>
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
	
	
	<doc:doc>
		<doc:title>Event Date: Year</doc:title>
	</doc:doc>
	<xsl:template match="event/date/@year">
		<span class="year">
			<xsl:value-of select="." />
		</span>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Event Date: Month</doc:title>
	</doc:doc>
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
	
	
	<doc:doc>
		<doc:title>Event Date: Day</doc:title>
	</doc:doc>
	<xsl:template match="event/date/@day">
		<span class="day">
			<xsl:value-of select="." />
		</span>
	</xsl:template>


	<doc:doc>
		<doc:title>Hyperlink: Event</doc:title>
		<doc:desc>
			<doc:p>Generates a hyperlink to an event.</doc:p>
		</doc:desc>
	</doc:doc>
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
	
</xsl:stylesheet>
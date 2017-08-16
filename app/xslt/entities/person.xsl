<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<xsl:key name="person" match="related/person" use="@id" />
	
	<xsl:template match="/app[view/data/entities/person] | /app[view/data/person]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>
	
	<xsl:template match="/app/view[data/entities/person]" mode="html.body">
		<xsl:apply-templates select="data/entities[person]"/>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/person]" mode="html.body">
		<xsl:apply-templates select="data/person" />
	</xsl:template>
	
	
	
	<xsl:template match="/app/view[data/entities/person]" mode="view.title">
		<xsl:text>People</xsl:text>
	</xsl:template>
	
	
	<xsl:template match="/app/view[data/person]" mode="view.title">
		<xsl:apply-templates select="data/person/persona[1]/name"/>
	</xsl:template>
	
	<xsl:template match="/app/view/data/person/persona/name">
		<xsl:value-of select="string-join(name, ' ')"/>
	</xsl:template>
	
	<xsl:template match="/app/view[data/person]" mode="html.body.title" priority="100">
		<xsl:next-match />
		<xsl:apply-templates select="data/person/persona[1]/gender" mode="glyph" />
	</xsl:template>
	
	
	<xsl:template match="data/entities[person]">
		<ul>
			<xsl:apply-templates>
				<xsl:sort select="name/string-join(name[@family = 'yes'], ' ')" data-type="text" order="ascending"/>
				<xsl:sort select="name/string-join(name[not(@family = 'yes')], ' ')" data-type="text" order="ascending"/>	
				<xsl:sort select="@year" data-type="number" order="ascending"/>
			</xsl:apply-templates>
		</ul>
	</xsl:template>
	
	<xsl:template match="data/person" priority="100">
		<xsl:next-match>
			<xsl:with-param name="subject-id" select="@id" as="xs:string" tunnel="yes" /> 
		</xsl:next-match>
	</xsl:template>
	
	<xsl:template match="data/person">
		<xsl:apply-templates select="persona" />
		<xsl:apply-templates select="related[event/@type = ('birth', 'christening', 'marriage')]" mode="family" />
		<xsl:apply-templates select="self::person[note]" mode="notes" /> 
		<xsl:apply-templates select="related[event]" mode="timeline" /> 
		<xsl:apply-templates select="related[location]" mode="map" />
	</xsl:template>
	
	
	<xsl:template match="person/persona">
		<div class="persona">
			<xsl:if test="preceding-sibling::persona">
				<h2>
                    <xsl:apply-templates select="name"/>
					<xsl:apply-templates select="gender" mode="glyph" />
                </h2>
			</xsl:if>
		</div>
	</xsl:template>
	
	
	<xsl:template match="person/name | person/persona/name" mode="href-html">
		<xsl:variable name="name" select="string-join(name, ' ')" as="xs:string?"/>
		<xsl:choose>
			<xsl:when test="$name = ''">[Unknown]</xsl:when>
			<xsl:otherwise>
                <xsl:value-of select="$name"/>
            </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<xsl:template match="entities/person">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	<xsl:template match="person[@id]" mode="href-html">
		<span class="person">
			<xsl:call-template name="href-html">
				<xsl:with-param name="path" select="concat('person/', @id)" as="xs:string"/>
				<xsl:with-param name="content" as="item()">
					<xsl:apply-templates select="persona[1]/name" mode="href-html"/>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:apply-templates select="persona[1]/gender" mode="glyph" />
		</span>
	</xsl:template>
	
	
	<xsl:template match="gender" mode="glyph">
		<xsl:choose>
			<xsl:when test="lower-case(.) = ('male', 'female', 'hermaphrodite', 'transgender', 'androgen')">
				<xsl:text> </xsl:text><span class="gender {lower-case(.)}"><xsl:value-of select="
					if (lower-case(.) = 'male')
					then '♂'
					else if (lower-case(.) = 'female')
					then '♀'
					else if (lower-case(.) = 'hermaphrodite')
					then '⚥'
					else if (lower-case(.) = 'transgender')
					then '⚧'
					else if (lower-case(.) = 'androgen')
					then '⚪'
					else ''
					" /></span>
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>People</doc:title>
		<doc:desc>
			<doc:p>All people associated with an entity.</doc:p>
		</doc:desc>
		<doc:note>
			<doc:p>In alphabetical order.</doc:p>
		</doc:note>
		<doc:note>
			<doc:p>When viewing a Person (entity), Family is used instead.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="related" mode="people">
		<xsl:variable name="people" select="person" as="element()*" />
		
		<div class="people">
			<h2>People</h2>
			<ul>
				<xsl:for-each select="fn:sort-people($people)">
					<li><xsl:apply-templates select="self::*" mode="href-html" /></li>
				</xsl:for-each>
			</ul>
		</div>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Family</doc:title>
		<doc:desc>
			<ol>
				<li>Parents</li>
				<li>Partners</li>
				<li>Children</li>
			</ol>
		</doc:desc>
		<doc:note>
			<doc:p>Excluding siblings for the time being.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="related" mode="family">
		<div class="family">
			<h2>Family</h2>
			<xsl:apply-templates select="self::*" mode="family.parents" />
			<xsl:apply-templates select="self::*" mode="family.partners" />
			<xsl:apply-templates select="self::*" mode="family.children" />
		</div>
	</xsl:template>
	
	
	
	<doc:doc>
		<doc:title>Family: Parents</doc:title>
		<doc:note>
			<doc:p>In alphabetical order.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="related" mode="family.parents">
		<xsl:param name="subject-id" as="xs:string" tunnel="yes" />
		
		<xsl:variable name="events" select="event[@type = 'birth'][person/@ref = $subject-id][parent]" as="element()*" />
		
		<xsl:if test="count($events) > 0">
			<xsl:variable name="people" select="$events/parent[@ref]" as="element()*" />
			
			<div class="parents">
				<h3>Parents</h3>
				<ul>
					<xsl:for-each select="fn:sort-people($people)">
						<li><xsl:apply-templates select="self::*" /></li>
					</xsl:for-each>
				</ul>
			</div>
		</xsl:if>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Family: Children</doc:title>
		<doc:note>
			<doc:p>In chronological order.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="related" mode="family.children">
		<xsl:param name="subject-id" as="xs:string" tunnel="yes" />
		
		<xsl:variable name="events" select="event[@type = 'birth'][parent/@ref = $subject-id][person]" as="element()*" />
		
		<xsl:if test="count($events) > 0">
			<div class="children">
				<h3>Children</h3>
				<ul>
					<xsl:for-each-group select="$events/person[@ref != $subject-id]/key('person', @ref)" group-by="@id">
						<xsl:sort select="date/@year" data-type="number" order="ascending" />
						<xsl:sort select="date/@month" data-type="number" order="ascending" />
						<xsl:sort select="date/@day" data-type="number" order="ascending" />
						
						<li><xsl:apply-templates select="self::*" mode="href-html" /></li>
					</xsl:for-each-group>
				</ul>
			</div>
		</xsl:if>
		
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Family: Partners</doc:title>
		<doc:note>
			<doc:p>In chronological order.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="related" mode="family.partners">
		<xsl:param name="subject-id" as="xs:string" tunnel="yes" />
		
		<xsl:variable name="events" select="event[@type = 'marriage'][person/@ref = $subject-id and person/@ref != $subject-id] | event[@type = 'birth'][parent/@ref = $subject-id and parent/@ref != $subject-id]" as="element()*" />
			
		<xsl:if test="count($events) > 0">
			<div class="partners">
				<h3>Partners</h3>
				<ul>
					<xsl:for-each-group select="$events" group-by="if (@type = 'marriage') then person/@ref[. != $subject-id] else parent/@ref[. != $subject-id]">
						<xsl:sort select="date/@year" data-type="number" order="ascending" />
						<xsl:sort select="date/@month" data-type="number" order="ascending" />
						<xsl:sort select="date/@day" data-type="number" order="ascending" />
						
						<li><xsl:apply-templates select="key('person', current-grouping-key())" mode="href-html" /></li>
					</xsl:for-each-group>
				</ul>
			</div>
		</xsl:if>
		
	</xsl:template>
	
	<xsl:template match="person[@ref] | parent[@ref]">
		<xsl:apply-templates select="key('person', @ref)" mode="href-html" />
	</xsl:template>

	
</xsl:stylesheet>
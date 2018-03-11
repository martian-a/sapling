<?xml-model href="http://ns.thecodeyard.co.uk/schema/cinnamon.sch?v=0.1.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<doc:doc>
		<doc:title>Key: Person</doc:title>
		<doc:desc>
			<doc:p>For quickly finding an person entity in the data, using it's ID.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="person" match="related/person | data/person | entities/person" use="@id" />
	

	<doc:doc>
		<doc:desc>
			<doc:p>HTML Head: person (entity)-specific style rules that need to go in the head of the HTML document.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app[view/data/person] | /app[view/data/entities/person]" mode="html.header.style" priority="500">
		<link href="{$normalised-path-to-css}person.css" type="text/css" rel="stylesheet" />
		<xsl:next-match />
	</xsl:template>


	<doc:doc>
		<doc:desc>
			<doc:p>HTML Head: person (entity)-specific scripts that need to go in the head of the HTML document.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app[view/data/person]" mode="html.header.scripts" priority="500">
		<script src="{$normalised-path-to-js}family_tree.js"><xsl:comment>origin: person</xsl:comment></script> 
		<xsl:next-match />
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>HTML Head: person (entity)-specific scripts that need to go in the foot of the HTML document.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app[view/data/person]" mode="html.footer.scripts" priority="500">
		<script src="{$normalised-path-to-js}init.js"><xsl:comment>origin: person</xsl:comment></script>
		<xsl:next-match />
	</xsl:template>



	<doc:doc>
		<doc:desc>
			<doc:p>People Index: initial template for creating the HTML body.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/entities/person]" mode="html.body">
		<xsl:apply-templates select="data/entities[person]"/>
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Person Profile: initial template for creating the HTML body.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/person]" mode="html.body">
		<xsl:apply-templates select="data/person" />
	</xsl:template>
	


	
	<doc:doc>
		<doc:title>Page Title: People index</doc:title>
		<doc:desc>
			<doc:p>The content to go in the page title of the index page for person entities.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/entities/person]" mode="view.title">
		<xsl:text>People</xsl:text>
	</xsl:template>
	
	

	<doc:doc>
		<doc:title>Page Title: Person entity profile page</doc:title>
		<doc:desc>
			<doc:p>Ensures that the content of the page title of an person entity profile page is a plain string.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view[data/person]" mode="view.title">
		<xsl:apply-templates select="data/person/persona[1]/name"/>
	</xsl:template>
	
	
	<!-- xsl:template match="/app/view[data/person]" mode="html.body.title" priority="50">
		<xsl:next-match/>
		<xsl:apply-templates select="data/person/persona[1]/gender" mode="glyph"/>
	</xsl:template -->
	
	

	<doc:doc>
		<doc:title>People Index</doc:title>
		<doc:desc>
			<doc:ul>
				<doc:ingress>Lists all person entities:</doc:ingress>
				<doc:li>in alphabetical order</doc:li>
				<doc:li>in chronological order</doc:li>
			</doc:ul>
		</doc:desc>
	</doc:doc>
	<xsl:template match="data/entities[person]">
		<div class="contents">
			<p>Browse by:</p>
			<ul>
				<li><a href="#nav-alpha">Surname</a></li>
				<li><a href="#nav-chronological">Birth Year</a></li>
			</ul>
		</div>		
		<div class="nav-index alphabetical" id="nav-alpha">
			<h2>By Surname
				<xsl:text> </xsl:text>
				<a href="#top" class="nav" title="Top of page">▴</a></h2>
			
			<xsl:variable name="entries" as="element()*">
				<xsl:for-each-group select="fn:sort-people(person)" group-by="persona[1]/name/name[@family = 'yes'][1]/substring(., 1, 1)">
					<xsl:call-template name="generate-jump-navigation-group">
						<xsl:with-param name="group" select="current-group()" as="element()*" />
						<xsl:with-param name="key" select="current-grouping-key()" as="xs:string" />
						<xsl:with-param name="misc-match-test" select="''" as="xs:string" />
						<xsl:with-param name="misc-match-label" select="'Surname Unknown'" as="xs:string" />
					</xsl:call-template>	
				</xsl:for-each-group>
			</xsl:variable>
			
			<xsl:call-template name="generate-jump-navigation">
				<xsl:with-param name="entries" select="$entries" as="element()*" />
				<xsl:with-param name="id" select="'nav-alpha'" as="xs:string" />
			</xsl:call-template>
		</div>
		
		<div class="nav-index chronological" id="nav-chronological">
			<h2>By Birth Year<a href="#note-1" class="note-glyph">*</a>
				<xsl:text> </xsl:text>
				<a href="#top" class="nav" title="Top of page">▴</a></h2>
			<p id="note-1" class="note"><span class="note-glyph">*</span> Or estimated birth year if actual not known</p>
			
			<xsl:variable name="entries" as="element()*">
				<xsl:for-each-group select="fn:sort-people(person)" group-by="@year">
					<xsl:sort select="@year" data-type="number" order="ascending" />
					<xsl:call-template name="generate-jump-navigation-group">
						<xsl:with-param name="group" select="current-group()" as="element()*" />
						<xsl:with-param name="key" select="current-grouping-key()" as="xs:string" />
						<xsl:with-param name="misc-match-test" select="''" as="xs:string" />
						<xsl:with-param name="misc-match-label" select="'Year Unknown'" as="xs:string" />
					</xsl:call-template>	
				</xsl:for-each-group>
			</xsl:variable>
			
			<xsl:call-template name="generate-jump-navigation">
				<xsl:with-param name="entries" select="$entries" as="element()*" />
				<xsl:with-param name="id" select="'nav-chronological'" as="xs:string" />
				<xsl:with-param name="base" select="''" as="xs:string" /> 
			</xsl:call-template>
			
			<!-- div class="multi-column">
				<xsl:for-each-group select="fn:sort-people(person)" group-by="@year">
					<xsl:sort select="@year" data-type="number" order="ascending" />
					<div>
						<h3>
							<xsl:value-of select="
									if (current-grouping-key() = '') then
										'Year Unknown'
									else
										current-grouping-key()" />
						</h3>
						<ul>
							<xsl:apply-templates select="current-group()" />
						</ul>
					</div>
				</xsl:for-each-group>
			</div -->
		</div>
	</xsl:template>
	


	<doc:doc>
		<doc:title>Person Profile: subject-id.</doc:title>
	</doc:doc>
	<xsl:template match="data/person" priority="100">
		<xsl:next-match>
			<xsl:with-param name="subject-id" select="@id" as="xs:string" tunnel="yes" /> 
		</xsl:next-match>
	</xsl:template>
	

	<doc:doc>
		<doc:title>Person Profile: layout template.</doc:title>
	</doc:doc>
	<xsl:template match="data/person">
		<xsl:apply-templates select="self::person[persona]" mode="personas" />
		<xsl:apply-templates select="related[event/@type = ('birth', 'christening', 'marriage')]" mode="family" />
		<xsl:apply-templates select="self::person[note]" mode="notes" /> 
		<xsl:apply-templates select="related[event]" mode="timeline" /> 
		<xsl:apply-templates select="related[organisation]" mode="organisations"/>
		<xsl:apply-templates select="related[location]" mode="locations" />
	    <xsl:apply-templates select="related[source]" mode="sources"/>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Person Profile: Additional Persona.</doc:title>
	</doc:doc>
	<xsl:template match="data/person" mode="personas">			
			<div class="personas">
			<xsl:for-each select="persona[1]">
				<p class="gender">
					<xsl:value-of select="gender"/>
					<xsl:apply-templates select="gender" mode="glyph.bracketed"/>
				</p>
			</xsl:for-each>
			<xsl:if test="count(persona) &gt; 1">
				<h2>Also Known As</h2>
				<ul>
					<xsl:for-each select="persona[preceding-sibling::persona]">
						<li>
							<xsl:apply-templates select="name"/>
							<xsl:apply-templates select="gender" mode="glyph.bracketed"/>
						</li>
					</xsl:for-each>
				</ul>
			</xsl:if>
		</div>
	</xsl:template>

	
	

	<doc:doc>
		<doc:title>People Index: List entry</doc:title>
	</doc:doc>
	<xsl:template match="entities/person | group/entries/person">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	
	<doc:doc>
		<doc:title>Gender Glyph: Whitespace Prefix</doc:title>
	</doc:doc>
	<xsl:template match="gender" mode="glyph glyph.bracketed" priority="50">
		<xsl:if test="lower-case(.) = ('male', 'female', 'hermaphrodite', 'transgender', 'androgyne')">
			<xsl:text> </xsl:text>
			<xsl:next-match/>
		</xsl:if>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Gender Glyph: Brackets</doc:title>
	</doc:doc>
	<xsl:template match="gender" mode="glyph.bracketed" priority="10">
		<xsl:text>(</xsl:text>
        <xsl:next-match/>
        <xsl:text>)</xsl:text>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Gender Glyph: Content</doc:title>
	</doc:doc>
	<xsl:template match="gender" mode="glyph glyph.bracketed">
        <span class="gender {lower-case(.)} glyph">
			<xsl:value-of select="
				if (lower-case(.) = 'male') then '♂'
				else if (lower-case(.) = 'female') then '♀'
				else if (lower-case(.) = 'hermaphrodite') then '⚥'
				else if (lower-case(.) = 'transgender') then '⚧'
				else if (lower-case(.) = 'androgyne') then '⚪'
				else ''" />
        </span>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Related: Person</doc:title>
		<doc:desc>
			<doc:p>Collect together all people related to the subject entity.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="related" mode="people" priority="10">
		<xsl:next-match>
			<xsl:with-param name="people" select="person" as="element()*" />
		</xsl:next-match>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Derived From: Person</doc:title>
		<doc:desc>
			<doc:p>Collect together all people from which a name is derived.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="derived-from" mode="people" priority="10">
		<xsl:next-match>
			<xsl:with-param name="people" select="person/key('person', @ref)" as="element()*" />
		</xsl:next-match>
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
	<xsl:template match="related | derived-from" mode="people">
		<xsl:param name="people" as="element()*" />
		
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
			<div class="list">
				<xsl:apply-templates select="self::*" mode="family.parents" />
				<xsl:apply-templates select="self::*" mode="family.partners" />
				<xsl:apply-templates select="self::*" mode="family.children" />
			</div>
			<xsl:apply-templates select="self::*" mode="family.network-graph" />
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
		<xsl:variable name="public-parents" select="$events/parent[@ref]" as="element()*" />
		
		<xsl:if test="count($public-parents) > 0">
			
			<div class="parents">
				<h3>Parents</h3>
				<ul>
					<xsl:for-each select="fn:sort-people($public-parents)">
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
		<xsl:variable name="public-children" select="$events/person[@ref != $subject-id]/key('person', @ref)" as="element()*" />
		
		<xsl:if test="count($public-children) > 0">
			<div class="children">
				<h3>Children</h3>
				<ul>
					<xsl:for-each select="$public-children">
						<xsl:sort select="if ($events[person/@ref = current()/@ref]/date/@year) then $events[person/@ref = current()/@ref]/date/@year else @year" data-type="number" order="ascending" />
						<xsl:sort select="$events[person/@ref = current()/@ref]/date/@month" data-type="number" order="ascending" />
						<xsl:sort select="$events[person/@ref = current()/@ref]/date/@day" data-type="number" order="ascending" />
						
						<li><xsl:apply-templates select="self::*" mode="href-html" /></li>
					</xsl:for-each>
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
		
		<xsl:variable name="events" as="element()*">
			<xsl:for-each  select="event[@type = 'marriage'][person/@ref = $subject-id and person/@ref != $subject-id] | event[@type = 'birth'][parent/@ref = $subject-id and parent/@ref != $subject-id]">
				<xsl:sort select="date/@year" data-type="number" order="ascending" />
				<xsl:sort select="date/@month" data-type="number" order="ascending" />
				<xsl:sort select="date/@day" data-type="number" order="ascending" />
				<xsl:sequence select="self::event" />
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="public-partners" select="($events[@type = 'marriage']/person[@ref != $subject-id] | $events[not(@type = 'marriage')]/parent[@ref != $subject-id])/key('person', @ref)" as="element()*" />
			
		<xsl:if test="count($public-partners) > 0">
			<div class="partners">
				<h3>Partners</h3>
				<ul>
					<xsl:for-each-group select="$public-partners" group-by="@id">
						<xsl:sort select="$events[*/@ref = current-grouping-key()][1]/date/@year" data-type="number" order="ascending" />
						<xsl:sort select="$events[*/@ref = current-grouping-key()][1]/date/@month" data-type="number" order="ascending" />
						<xsl:sort select="$events[*/@ref = current-grouping-key()][1]/date/@day" data-type="number" order="ascending" />
						
						<li><xsl:apply-templates select="current-group()[1]" mode="href-html" /></li>
					</xsl:for-each-group>
				</ul>
			</div>
		</xsl:if>
		
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Family: Network Graph</doc:title>
		<doc:note>
			<doc:p>SVG.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="related" mode="family.network-graph">
		<xsl:param name="subject-id" as="xs:string" tunnel="yes" />
				
		<div class="network-graph">
			<h3>Family Tree</h3>
			<div class="network-visualisation">
				<xsl:variable name="data-url" as="xs:string*">
					<xsl:choose>
						<xsl:when test="$static = 'true'">
							<xsl:value-of select="$normalised-path-to-images" />
							<xsl:text>network-graphs/svg/person/landscape</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$normalised-path-to-view-svg" />
							<xsl:text>person</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
					<xsl:value-of select="concat('/', $subject-id)" />
					<xsl:choose>
						<xsl:when test="$static = 'true'">
							<xsl:text>.svg</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:text>/family-tree/landscape/</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<object id="family-tree" data="{string-join($data-url, '')}" type="image/svg+xml">
					<xsl:if test="$static = 'true'">						
						<img src="{concat($normalised-path-to-images, 'network-graphs/png/person/landscape')}/{$subject-id}.png" />
					</xsl:if>
				</object>
			</div>
		</div>
		
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Cross-reference: Person</doc:title>
		<doc:desc>
			<doc:p>Hyperlinks a cross-reference to a person entity.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="person[@ref] | parent[@ref]">
		<xsl:variable name="public-record" select="key('person', @ref)" as="element()?" />
		
		<xsl:choose>
			<xsl:when test="count($public-record) &gt; 0">
				<xsl:apply-templates select="$public-record" mode="href-html">
					<xsl:with-param name="style" select="if (@style != '') then @style else 'formal'" as="xs:string?" tunnel="yes"/>
				</xsl:apply-templates>					
			</xsl:when>
			<xsl:otherwise>[name witheld]</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


	<doc:doc>
		<doc:title>Hyperlink: Person (Wrapper)</doc:title>
		<doc:desc>
			<doc:p>Generates a hyperlink to an event.</doc:p>
		</doc:desc>
		<doc:note>
			<doc:p>Also appends gender glyph to name.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="person[@id]" mode="href-html">
		<xsl:param name="style" select="'formal'" tunnel="yes" as="xs:string?"/>
		<xsl:param name="inline-value" as="xs:string?" tunnel="yes"/>
		
		<span class="person">
			<xsl:call-template name="href-html">
				<xsl:with-param name="path" select="concat('person/', @id)" as="xs:string"/>
				<xsl:with-param name="content" as="item()">
					<xsl:choose>
						<xsl:when test="$inline-value != ''"><xsl:value-of select="$inline-value"/></xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="persona[1]/name" mode="href-html"/>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:with-param>
			</xsl:call-template>
			<xsl:if test="$style = 'formal'">
				<xsl:apply-templates select="persona[1]/gender" mode="glyph"/>
			</xsl:if>
		</span>
	</xsl:template>
	

	<doc:doc>
		<doc:title>Hyperlink: Person (Content)</doc:title>
	</doc:doc>
	<xsl:template match="person/persona/name" mode="href-html">
		<xsl:param name="style" select="'formal'" tunnel="yes" as="xs:string?"/>
	<xsl:value-of select="fn:get-name(ancestor::person[1], parent::persona, $style)"/>
	</xsl:template>


	<doc:doc>
		<doc:title>Name: Person</doc:title>
	</doc:doc>
	<xsl:template match="person/persona/name">
		<xsl:value-of select="string-join(name, ' ')"/>
	</xsl:template>
	
</xsl:stylesheet>
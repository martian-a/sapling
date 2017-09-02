<?xml-model href="http://ns.thecodeyard.co.uk/schema/cinnamon.sch?v=0.1.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">
	
	<doc:doc>
		<doc:title>Key: Person</doc:title>
		<doc:desc>
			<doc:p>For quickly finding an person entity in the data, using it's ID.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="person" match="related/person | data/person | entities/person" use="@id" />
	

	<doc:doc>
		<doc:desc>
			<doc:p>HTML Head: person (entity)-specific content that needs to go in the head of the HTML document.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/app[view/data/entities/person] | /app[view/data/person]" mode="html.header html.header.scripts html.header.style html.footer.scripts"/>


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
		<div class="alphabetical">
			<h2>Alphabetical</h2>
			<div class="multi-column">
				<xsl:for-each-group select="fn:sort-people(person)" group-by="persona[1]/name/name[@family = 'yes'][1]/substring(., 1, 1)">
					<div>
						<h3>
							<xsl:value-of select="
									if (current-grouping-key() = '') then
										'Surname Unknown'
									else
										current-grouping-key()" />
						</h3>
						<ul>
							<xsl:apply-templates select="current-group()" />
						</ul>
					</div>
				</xsl:for-each-group>
			</div>
		</div>
		<div class="chronological">
			<h2>Chronological</h2>
			<div class="multi-column">
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
			</div>
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
		<xsl:apply-templates select="persona" />
		<xsl:apply-templates select="related[event/@type = ('birth', 'christening', 'marriage')]" mode="family" />
		<xsl:apply-templates select="self::person[note]" mode="notes" /> 
		<xsl:apply-templates select="related[event]" mode="timeline" /> 
		<xsl:apply-templates select="related[organisation]" mode="organisations"/>
		<xsl:apply-templates select="related[location]" mode="map" />
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Person Profile: Additional Persona.</doc:title>
	</doc:doc>
	<xsl:template match="person/persona">
		<div class="persona">
			<xsl:if test="preceding-sibling::persona">
				<h2>
                    <xsl:apply-templates select="name"/>
					</h2>
			</xsl:if>
			<p class="gender">
                <xsl:value-of select="gender"/>
                <xsl:apply-templates select="gender" mode="glyph.bracketed"/>
            </p>
		</div>
	</xsl:template>

	
	

	<doc:doc>
		<doc:title>People Index: List entry</doc:title>
	</doc:doc>
	<xsl:template match="entities/person">
		<li>
			<xsl:apply-templates select="self::*" mode="href-html"/>
		</li>
	</xsl:template>
	
	
	
	<doc:doc>
		<doc:title>Gender Glyph: Whitespace Prefix</doc:title>
	</doc:doc>
	<xsl:template match="gender" mode="glyph glyph.bracketed" priority="50">
		<xsl:if test="lower-case(.) = ('male', 'female', 'hermaphrodite', 'transgender', 'androgen')">
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
        <span class="gender {lower-case(.)}">
			<xsl:value-of select="
				if (lower-case(.) = 'male') then '♂'
				else if (lower-case(.) = 'female') then '♀'
				else if (lower-case(.) = 'hermaphrodite') then '⚥'
				else if (lower-case(.) = 'transgender') then '⚧'
				else if (lower-case(.) = 'androgen') then '⚪'
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
			<xsl:apply-templates select="self::*" mode="family.parents" />
			<xsl:apply-templates select="self::*" mode="family.partners" />
			<xsl:apply-templates select="self::*" mode="family.children" />
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
	
	
	<doc:doc>
		<doc:title>Family: Network Graph</doc:title>
		<doc:note>
			<doc:p>SVG.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template match="related" mode="family.network-graph">
		<xsl:param name="subject-id" as="xs:string" tunnel="yes" />
				
		<div class="network-graph">
			<h3>Network Graph</h3>
			<div class="network-visualisation">
				<object data="{if ($static = 'true') then concat($normalised-path-to-images, 'network-graphs/svg/') else $normalised-path-to-view-svg}person/{$subject-id}" type="image/svg+xml">
					<img src="{if ($static = 'true') then concat($normalised-path-to-images, 'network-graphs/svg/') else $normalised-path-to-view-svg}person/{$subject-id}" />
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
		<xsl:apply-templates select="key('person', @ref)" mode="href-html" />
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
	

	<doc:doc>
		<doc:title>Hyperlink: Person (Content)</doc:title>
	</doc:doc>
	<xsl:template match="person/persona/name" mode="href-html">
		<xsl:value-of select="fn:get-name(ancestor::person[1], parent::persona)" />
	</xsl:template>


	<doc:doc>
		<doc:title>Name: Person</doc:title>
	</doc:doc>
	<xsl:template match="/app/view/data/person/persona/name">
		<xsl:value-of select="string-join(name, ' ')"/>
	</xsl:template>
	
</xsl:stylesheet>
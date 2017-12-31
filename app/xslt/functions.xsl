<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" version="2.0">
	
	
	<xsl:variable name="romantic-relationship-start-types" select="('unmarried-partnership' , 'engagement', 'marriage')" as="xs:string*" />
	<xsl:variable name="romantic-relationship-end-types" select="('separation', 'divorce')" as="xs:string*" />
	<xsl:variable name="romantic-relationship-types" select="($romantic-relationship-start-types, $romantic-relationship-end-types)" as="xs:string*" />
	<xsl:variable name="parental-relationship-types" select="('birth' , 'christening', 'adoption')" as="xs:string*" />

	<xsl:function name="fn:add-trailing-slash" as="xs:string">
		<xsl:param name="string-in" as="xs:string?"/>
		
		<xsl:value-of select="concat($string-in, if (ends-with($string-in, '/')) then '' else '/')"/>
	</xsl:function>
	
	<xsl:function name="fn:title-case" as="xs:string?">
		<xsl:param name="string-in" as="xs:string?" />
		
		<xsl:variable name="result" as="xs:string*">
			<xsl:for-each select="tokenize($string-in, ' ')">
				<xsl:variable name="initial" select="upper-case(substring(., 1, 1))" as="xs:string?" />
				<xsl:variable name="remainder" select="substring(., 2)" as="xs:string?" />
				<xsl:value-of select="concat($initial, $remainder)" />	
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:value-of select="string-join($result, ' ')" />
		
	</xsl:function>
	
	
	<xsl:function name="fn:sort-people" as="element()*">
		<xsl:param name="people-in" as="element()*" />
		
		<xsl:for-each select="$people-in">
			<xsl:sort select="fn:get-sort-name(self::*)" data-type="text" order="ascending" />
			<xsl:sort select="@year" data-type="number" order="ascending"/>
			<xsl:sequence select="self::*" />
		</xsl:for-each>
		
	</xsl:function>
	
	
	<xsl:function name="fn:sort-locations" as="element()*">
		<xsl:param name="locations-in" as="element()*" />
		
		<xsl:for-each select="$locations-in">
			<xsl:sort select="fn:get-location-sort-name(self::*)" data-type="text" order="ascending" />
			<xsl:sort select="name[1]" data-type="text" order="ascending"/>
			<xsl:sequence select="self::*" />
		</xsl:for-each>
	</xsl:function>
	
	
	<xsl:function name="fn:get-location-context" as="element()*">
		<xsl:param name="location-in" as="element()" />
		
		<xsl:variable name="full-context" select="fn:get-full-location-context($location-in)" as="element()*" />
		
		<xsl:if test="$location-in/@type = 'address'">
			<xsl:sequence select="$full-context[not(@type = ('country', 'continent'))][position() != last()][preceding-sibling::*/@type != 'settlement']" />		
		</xsl:if>
		
		<xsl:choose>
			<xsl:when test="$full-context[@type = ('country', 'continent')]">
				<xsl:sequence select="$full-context[@type = ('country', 'continent')][1]" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="$full-context[position() = last()]" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-full-location-context" as="element()*">
		<xsl:param name="location-in" as="element()" />
		
		<xsl:variable name="context" select="$location-in/ancestor::document-node()/key('location', $location-in/within[1]/@ref)" as="element()?" />
		<xsl:sequence select="$context" />
		<xsl:if test="$context/within">
			<xsl:sequence select="fn:get-full-location-context($context)" />
		</xsl:if>
		
	</xsl:function>
	
	
	<!-- Get all locations within the specified location, including locations within locations. -->
	<xsl:function name="fn:get-locations-within" as="element()*">
		<xsl:param name="location-in" as="element()" />
		
		<xsl:sequence select="fn:get-locations-within($location-in, 0)" />
	</xsl:function>
	
	
	<!-- Get a list of locations within a specified location. -->
	<xsl:function name="fn:get-locations-within" as="element()*">
		<xsl:param name="location-in" as="element()" />
		<xsl:param name="depth" as="xs:integer" />
		
		<xsl:for-each select="$location-in/key('location-within', @id)">
			<xsl:sequence select="current()" /> 
			<xsl:choose>
				<xsl:when test="$depth = 0">
					<xsl:sequence select="fn:get-locations-within(current(), $depth)" />
				</xsl:when>
				<xsl:when test="$depth &gt; 1">
					<xsl:sequence select="fn:get-locations-within(current(), $depth - 1)" />
				</xsl:when>
			</xsl:choose>
		</xsl:for-each>
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-default-persona" as="element()?">
		<xsl:param name="person-in" as="element()?" />
		
		<xsl:sequence select="$person-in/persona[1]" />
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-name" as="xs:string">
		<xsl:param name="person-in" as="element()" />
		
		<xsl:variable name="person" select="$person-in/key('person', self::*/(@ref | @id))" as="element()*" />
			
		<xsl:value-of select="fn:get-name($person-in, fn:get-default-persona($person), 'formal')"/>
			
	</xsl:function>
	
	
	<xsl:function name="fn:get-name" as="xs:string">
		<xsl:param name="person-in" as="element()" />
		<xsl:param name="persona" as="element()?" />
		
		<xsl:param name="style" as="xs:string"/>
		
		<xsl:variable name="name" as="xs:string?">
			<xsl:choose>
				<xsl:when test="$style = 'familiar'">
					<xsl:value-of select="normalize-space($persona/name/name[not(@family = 'yes')][1])"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="normalize-space(string-join($persona/name/*, ' '))"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="$name = ''">[Unknown]</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-sort-name" as="xs:string?">
		<xsl:param name="person-in" as="element()" />
		
		<xsl:variable name="person" select="if ($person-in/@ref) then $person-in/key('person', @ref) else $person-in" as="element()" />
		<xsl:variable name="default-persona" select="fn:get-default-persona($person)" as="element()?" />
		<xsl:value-of select="fn:get-sort-name($person, $default-persona)" />
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-sort-name" as="xs:string?">
		<xsl:param name="person-in" as="element()" />
		<xsl:param name="persona" as="element()?" />
		
		<xsl:value-of select="normalize-space(concat(string-join($persona/name/name[@family = 'yes'], ' '), ' ', string-join($persona/name/name[not(@family = 'yes')], ' ')))" />
		
	</xsl:function>
	

	<xsl:function name="fn:get-location-sort-name" as="xs:string?">
		<xsl:param name="location-in" as="element()" />
		
		<xsl:variable name="name" select="$location-in/name[1]/lower-case(.)" as="xs:string?" />
		
		<xsl:variable name="non-alpha-characters" select="translate($name, 'abcdefghijklmnopqrstuvwxyz', '')" as="xs:string?" />
		<xsl:variable name="first-letter" select="substring(translate($name, $non-alpha-characters, ''), 1, 1)" />
		<xsl:value-of select="normalize-space(concat($first-letter, substring-after($name, $first-letter)))" />	
		
	</xsl:function>
	

	<xsl:function name="fn:get-sorted-parents" as="element()*">
		<xsl:param name="event" as="element()"/>

		<xsl:sequence select="fn:get-sorted-persons($event, 'parent')" />
			
	</xsl:function>
	
	
	<xsl:function name="fn:get-sorted-persons" as="element()*">
		<xsl:param name="event" as="element()"/>
		
		<xsl:sequence select="fn:get-sorted-persons($event, 'person')" />
	</xsl:function>	
		
	
	<xsl:function name="fn:get-sorted-persons" as="element()*">
		<xsl:param name="event" as="element()"/>
		<xsl:param name="role" as="xs:string" />
		
		<xsl:for-each select="$event/*[name() = $role]">
			<xsl:sort select="current()/key('person', @ref)/@year" />
			<xsl:sort select="fn:get-sort-name(self::*)" data-type="text" order="ascending" />
			<xsl:sort select="number(substring-after(@ref, 'PER'))" data-type="number" order="ascending" />
			<xsl:sequence select="current()" />
		</xsl:for-each>
		
	</xsl:function>
	
	
	
	
	<xsl:function name="fn:get-inferred-relationship-id" as="xs:string?">
		<xsl:param name="event" as="element()" />
		
		<xsl:variable name="unsorted-people" select="if ($event/@type = $parental-relationship-types) then $event/parent else $event/person" as="element()*" />
		<xsl:variable name="sorted-people" as="element()*">
			<xsl:perform-sort select="$unsorted-people">
				<xsl:sort select="@ref" />
			</xsl:perform-sort>
		</xsl:variable>
		
		<xsl:value-of select="for $person in $sorted-people return $person/@ref" separator="" />
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-events-involving-people" as="element()*">
		<xsl:param name="people" as="element()*" />
		
		<xsl:sequence select="fn:get-events-involving-people($people, $people[1]/ancestor::data[1]/*/related/event)" />
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-events-involving-people" as="element()*">
		<xsl:param name="people" as="element()*" />
		<xsl:param name="candidate-events" as="element()*" />
		
		<xsl:variable name="events-involving-person-1" select="fn:get-events-involving-person($people[1], $candidate-events)" as="element()*" />
		<xsl:choose>
			<xsl:when test="count($people) = 1">
				<xsl:sequence select="$events-involving-person-1" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:sequence select="fn:get-events-involving-people($people[position() != 1], $events-involving-person-1)" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-events-involving-person" as="element()*">
		<xsl:param name="person" as="element()" />
		
		<xsl:sequence select="fn:get-events-involving-person($person, $person/ancestor::data[1]/*/related/event)" />
		
	</xsl:function>
	
	<xsl:function name="fn:get-events-involving-person" as="element()*">
		<xsl:param name="person" as="element()" />
		<xsl:param name="candidate-events" as="element()*" />
		
		<xsl:sequence select="$candidate-events[descendant::person/@ref = $person/(@id | @ref) or parent/@ref = $person/(@id | @ref)]" />
		
	</xsl:function>	
		
		
	
	<xsl:function name="fn:get-birth-events" as="element()*">
		<xsl:param name="person-in" as="element()" />
		
		<xsl:sequence select="fn:get-birth-events($person-in, 'person')" />
	</xsl:function>
	
	
	<xsl:function name="fn:get-birth-events" as="element()*">
		<xsl:param name="person-in" as="element()" />
		<xsl:param name="role" as="xs:string" />
		
		<xsl:for-each select="fn:get-events-involving-person($person-in)[@type = $parental-relationship-types][*[name() = $role]/@ref = $person-in/(@id | @ref)]">
			<xsl:sort select="date/@year" data-type="number" order="ascending" />
			<xsl:sort select="date/@month" data-type="number" order="ascending" />
			<xsl:sort select="date/@day" data-type="number" order="ascending" />
			<xsl:sequence select="current()" />
		</xsl:for-each>
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-partner-events" as="element()*">
		<xsl:param name="person-in" as="element()" />
		
		<xsl:for-each select="fn:get-events-involving-person($person-in)[@type = $romantic-relationship-types][person/@ref = $person-in/(@id | @ref)][person/@ref != $person-in/(@id | @ref)] | fn:get-birth-events($person-in, 'parent')[parent/@ref != $person-in/(@id | @ref)]">
			<xsl:sort select="date/@year" data-type="number" order="ascending" />
			<xsl:sort select="date/@month" data-type="number" order="ascending" />
			<xsl:sort select="date/@day" data-type="number" order="ascending" />
			<xsl:sequence select="current()" />
		</xsl:for-each>
		
	</xsl:function>
		
</xsl:stylesheet>
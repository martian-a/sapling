<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" version="2.0">
	
	<xsl:function name="fn:add-trailing-slash" as="xs:string">
		<xsl:param name="string-in" as="xs:string?"/>
		
		<xsl:value-of select="concat($string-in, if (ends-with($string-in, '/')) then '' else '/')"/>
	</xsl:function>
	
	<xsl:function name="fn:title-case" as="xs:string?">
		<xsl:param name="string-in" as="xs:string?" />
		
		<xsl:variable name="initial" select="upper-case(substring($string-in, 1, 1))" as="xs:string?" />
		<xsl:variable name="remainder" select="substring($string-in, 2)" as="xs:string?" />
		<xsl:value-of select="concat($initial, $remainder)" />
		
	</xsl:function>
	
	
	<xsl:function name="fn:sort-people" as="element()*">
		<xsl:param name="people-in" as="element()*" />
		
		<xsl:for-each select="$people-in">
			<xsl:sort select="persona/name/name[@family = 'yes']" data-type="text" order="ascending" />
			<xsl:sort select="string-join(persona/name/name[not(@family = 'yes')], ' ')" data-type="text" order="ascending" />
			<xsl:sort select="@year" data-type="number" order="ascending"/>
			<xsl:sequence select="self::*" />
		</xsl:for-each>
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-location-context" as="element()?">
		<xsl:param name="location-in" as="element()" />
		
		<xsl:variable name="full-context" select="fn:get-full-location-context($location-in)" as="element()*" />
		
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
		
		<xsl:variable name="context" select="$location-in/key('location', within[1]/@ref)" as="element()?" />
		<xsl:sequence select="$context" />
		<xsl:if test="$context/within">
			<xsl:sequence select="fn:get-full-location-context($context)" />
		</xsl:if>
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-locations-within" as="element()*">
		<xsl:param name="location-in" as="element()" />
		
		<xsl:for-each select="$location-in/key('location-within', @id)">
			<xsl:sequence select="current()" /> 
			<xsl:sequence select="fn:get-locations-within(current())" />
		</xsl:for-each>
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-default-persona" as="element()?">
		<xsl:param name="person-in" as="element()" />
		
		<xsl:sequence select="$person-in/persona[1]" />
		
	</xsl:function>
	
	
	<xsl:function name="fn:get-name" as="xs:string">
		<xsl:param name="person-in" as="element()" />
				
		<xsl:value-of select="fn:get-name($person-in, fn:get-default-persona($person-in/key('person', (@ref | @id))))" />
			
	</xsl:function>
	
	
	<xsl:function name="fn:get-name" as="xs:string">
		<xsl:param name="person-in" as="element()" />
		<xsl:param name="persona" as="element()" />
		
		<xsl:variable name="name" select="normalize-space(string-join($persona/name/*, ' '))" as="xs:string?"/>
		
		<xsl:choose>
			<xsl:when test="$name = ''">[Unknown]</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
	
</xsl:stylesheet>
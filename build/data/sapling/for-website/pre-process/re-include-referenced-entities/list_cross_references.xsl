<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />
    
   
    <xsl:template match="/">
    	<xsl:variable name="cross-references" as="xs:string*">
    		<xsl:variable name="people" select="/data/include/descendant::person/@ref" as="xs:string*" />
    		<xsl:variable name="events" select="/data/exclude/events/event[person/@ref = /data/include/people/person/@id]/@id" as="xs:string*" />    		
    		<xsl:variable name="locations" select="/data/exclude/locations/location[@id = /data/include/descendant::location/@ref]/fn:get-location-in-context(self::location)" as="xs:string*" />
    		<xsl:variable name="sources" select="/data/include/descendant::source/concat(@ref, @extract)" as="xs:string*" />
    		<xsl:sequence select="distinct-values(($people, $events, $locations, $sources))" />
    	</xsl:variable>
    	<cross-references>
    		<xsl:for-each-group select="(/data/exclude/*/*[concat(@id, body-matter/extract/@id) = $cross-references])" group-by="parent::*/name()">
    			<xsl:element name="{current-grouping-key()}">
    				<xsl:sequence select="current-group()" />		
    			</xsl:element>
    		</xsl:for-each-group>    		
    	</cross-references>
    </xsl:template>
	
	<xsl:function name="fn:get-location-in-context" as="xs:string*">
		<xsl:param name="location" as="element()?" />
		
		<xsl:sequence select="$location/@id, $location/parent::locations/location[@id = $location/within/@ref]/fn:get-location-in-context(self::location)" />
	</xsl:function>
    
</xsl:stylesheet>
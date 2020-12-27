<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bio="http://purl.org/vocab/bio/0.1/"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:digest="http://nwalsh.com/xslt/ext/com.nwalsh.xslt.Digest"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
    xmlns:functx="http://www.functx.com"
    xmlns:gn="http://www.geonames.org/ontology#" 
    xmlns:greg="http://www.w3.org/ns/time/gregorian#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rel="http://purl.org/vocab/relationship/"
    xmlns:sap="http://ns.thecodeyard.co.uk/data/sapling/resource/#"
    xmlns:time="http://www.w3.org/2006/time#"    
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs fn functx digest"
    version="3.0">    
    
    <xsl:param name="resource-base-uri" select="'http://ns.thecodeyard.co.uk/data/sapling/'" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">
        <rdf:RDF>                     
            <xsl:apply-templates />
            <!-- xsl:for-each-group select="//location" group-by="fn:generate-location-id(self::location)">
                <gn:Feature rdf:about="http://ns.thecodeyard.co.uk/data/sapling/resource/location/{current-grouping-key()}">
                    <gn:name><xsl:value-of select="normalize-space(.)" /></gn:name>
                </gn:Feature>
            </xsl:for-each-group -->
        </rdf:RDF>        
    </xsl:template>       
    
    <xsl:template match="people/person/persona" priority="10">
        <xsl:variable name="id" select="if (preceding-sibling::persona) then @id else translate(ancestor::person[1]/@id, '@', '')" as="xs:string" />
        <foaf:Person rdf:about="{$resource-base-uri}resource/person/{$id}">
            <xsl:next-match />    
        </foaf:Person>        
    </xsl:template>
    
    <xsl:template match="people/person/persona">
        <xsl:apply-templates select="name[normalize-space() != '']" />
        <xsl:apply-templates select="gender[normalize-space() != '']" />
        <xsl:apply-templates select="/data/events/event[@type = 'birth'][date[@month and @day]][person/@ref = current()/ancestor::person[1]/@id]" mode="person" />
        <xsl:if test="preceding-sibling::persona">
            <xsl:apply-templates select="ancestor::person[1]/persona[1]" mode="sameAs" />
        </xsl:if>        
    </xsl:template>
    
    <xsl:template match="persona" mode="sameAs">
        <owl:sameAs rdf:resource="{$resource-base-uri}resource/person/{translate(ancestor::person[1]/@id, '@', '')}" />
    </xsl:template>
    
    <xsl:template match="persona/name">
        <foaf:name rdf:datatype="http://www.w3.org/2001/XMLSchema#string"><xsl:value-of select="string-join(name/text(), ' ')" /></foaf:name>
        <xsl:apply-templates select="name" />
    </xsl:template>
    
    <xsl:template match="persona/name/name[@family = 'yes']">
        <foaf:familyName rdf:datatype="http://www.w3.org/2001/XMLSchema#string"><xsl:value-of select="." /></foaf:familyName>
    </xsl:template>
    
    <xsl:template match="persona/name/name[not(@family = 'yes')]">
        <foaf:givenName rdf:datatype="http://www.w3.org/2001/XMLSchema#string"><xsl:value-of select="." /></foaf:givenName>
    </xsl:template>
    
    <xsl:template match="gender">
        <foaf:gender rdf:datatype="http://www.w3.org/2001/XMLSchema#string"><xsl:value-of select="lower-case(.)" /></foaf:gender>
    </xsl:template>
    
    <xsl:template match="event[@type = 'birth']" mode="person">
        <xsl:where-populated>
            <foaf:birthday rdf:datatype="http://www.w3.org/2001/XMLSchema#string"><xsl:value-of select="string-join((date/@month/functx:pad-integer-to-length(number(), 2), date/@day/functx:pad-integer-to-length(number(), 2)), '-')" /></foaf:birthday>    
        </xsl:where-populated>        
    </xsl:template>
    
    <xsl:template match="event[not(@type = 'birth')]" />
    
    <xsl:template match="event[@type = 'birth']">
        <bio:Birth rdf:about="{$resource-base-uri}resource/event/{generate-id()}">
            <xsl:apply-templates select="date" />
            <xsl:apply-templates select="person" />
            <xsl:apply-templates select="parent" />
            <!-- xsl:apply-templates select="location" /-->            
        </bio:Birth>
        <xsl:apply-templates select="person[parent::event/parent]" mode="relationship" />
    </xsl:template>
    
    <xsl:template match="date">
        <xsl:if test="@year and @month and @day">
            <dc:date><xsl:value-of select="string-join((@year, functx:pad-integer-to-length(@month, 2), functx:pad-integer-to-length(@day, 2)), '-')" /></dc:date>
        </xsl:if>
        <xsl:apply-templates select="@year, @month, @day" />
    </xsl:template>
    
    <xsl:template match="date/@year">
        <time:year rdf:datatype="xsd:gYear"><xsl:value-of select="."/></time:year>
    </xsl:template>
    
    <xsl:template match="date/@month">
        <time:monthOfYear><xsl:element name="greg:{('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December')[position() = number(current())]}" /></time:monthOfYear>
    </xsl:template>
    
    <xsl:template match="date/@day">
        <time:day rdf:datatype="xsd:gDay"><xsl:value-of select="."/></time:day>
    </xsl:template>
    
    <xsl:template match="event[@type = 'birth']/person">
        <bio:principal rdf:resource="{$resource-base-uri}resource/person/{translate(@ref, '@', '')}"/>
    </xsl:template>
    
    <xsl:template match="event[@type = 'birth']/parent">
        <bio:parent rdf:resource="{$resource-base-uri}resource/person/{translate(@ref, '@', '')}"/>
    </xsl:template>
    
    <xsl:template match="event/location">
        <!-- bio:place rdf:resource="{$resource-base-uri}resource/location/{fn:generate-location-id(self::location)}"/ -->
    </xsl:template>    
    
    
    <xsl:template match="event[@type = 'birth']/person" mode="relationship">
        <foaf:Person rdf:about="{$resource-base-uri}resource/person/{translate(@ref, '@', '')}">
            <xsl:for-each select="parent::event/parent">
                <rel:childOf rdf:resource="{$resource-base-uri}resource/person/{translate(@ref, '@', '')}" />
                <rel:descendantOf rdf:resource="{$resource-base-uri}resource/person/{translate(@ref, '@', '')}" />
            </xsl:for-each>    
        </foaf:Person>        
    </xsl:template>
    
    
    <xsl:template match="source" />
    
    
    <xsl:function name="functx:pad-integer-to-length" as="xs:string">
        <xsl:param name="integerToPad" as="xs:anyAtomicType?"/>
        <xsl:param name="length" as="xs:integer"/>
        
        <xsl:sequence select="
            if ($length &lt; string-length(string($integerToPad)))
            then error(xs:QName('functx:Integer_Longer_Than_Length'))
            else concat
            (functx:repeat-string(
            '0',$length - string-length(string($integerToPad))),
            string($integerToPad))
            "/>
        
    </xsl:function>
    
    <xsl:function name="functx:repeat-string" as="xs:string">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>
        
        <xsl:sequence select="
            string-join((for $i in 1 to $count return $stringToRepeat),
            '')
            "/>
        
    </xsl:function>
    
    <!-- xsl:function name="fn:generate-location-id" as="xs:string">
        <xsl:param name="location" as="element()" />

        <xsl:value-of select="digest:md5($location/normalize-space(.))" />
    </xsl:function -->
    
</xsl:stylesheet>
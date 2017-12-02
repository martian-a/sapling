<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	exclude-result-prefixes="#all"
	version="2.0">
	
	<doc:doc>
		<doc:desc>
			<doc:p>Filter source data, preparing it for distribution.</doc:p>
			<doc:ul>
				<doc:ingress>Actions include:</doc:ingress>
				<doc:li>exclude person records that aren't yet ready for publishing</doc:li>
				<doc:li>exclude event records that aren't related to a publishable person</doc:li>
				<doc:li>exclude organisation records that aren't related to a publishable person or event</doc:li>
				<doc:li>exclude location records that aren't related to a publishable person, event or organisation</doc:li>
				<doc:li>anonymise or remove cross-references to person records that aren't yet ready for publishing</doc:li>
			</doc:ul>
		</doc:desc>
	</doc:doc>
	
	
	
	<doc:doc>
		<doc:title>Key: Person</doc:title>
		<doc:desc>
			<doc:p>For quickly finding a person entity in the data, using it's ID.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="person" match="/app/data/people/person[@publish = 'true']" use="@id" />
	
	
	<doc:doc>
		<doc:title>Key: Location</doc:title>
		<doc:desc>
			<doc:p>For quickly finding a location entity in the data, using it's ID.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="location" match="/app/data/locations/location" use="@id" />
	
	
	<doc:doc>
		<doc:title>Key: Location within</doc:title>
		<doc:desc>
			<doc:p>For quickly finding location entities that are within a specified location.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="location-within" match="/app/data/locations/location" use="within/@ref" />



	<doc:doc>
		<doc:title>Unpublished Events</doc:title>
		<doc:desc>
			<doc:p>A look-up list of all events that shoudn't be published because they don't involve a published person.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:variable name="unpublished-events" as="element()*">
		<xsl:for-each select="/app/data/events/event">
			<xsl:variable name="people" select="descendant::*[name() = ('person', 'parent')][@ref]/key('person', @ref)" as="element()*" />
			<xsl:if test="count($people) = 0">
				<xsl:sequence select="self::*" />
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>


	<doc:doc>
		<doc:title>Unpublished Organisations</doc:title>
		<doc:desc>
			<doc:p>A look-up list of all organisations that shoudn't be published because they don't involve a published person, either directly or indirectly via a cross-reference.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:variable name="unpublished-organisations" as="element()*">
		<xsl:for-each select="/app/data/organisations/organisation">
			<xsl:variable name="references-from-published-entities" as="element()*">
				
				<!-- references from published people -->
				<xsl:sequence select="/app/data/people/person[@publish = 'true']/descendant::organisation[@ref = current()/@id]" />
				
				<!-- references from published events -->
				<xsl:sequence select="/app/data/events/event[not(@id = $unpublished-events/@id)]/descendant::organisation[@ref = current()/@id]" />
			</xsl:variable>
			
			<xsl:if test="count($references-from-published-entities) = 0">
				<xsl:sequence select="self::*" />
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	
	<doc:doc>
		<doc:title>Unpublished Locations</doc:title>
		<doc:desc>
			<doc:p>A look-up list of all locations that shoudn't be published because they don't involve a published person, either directly or indirectly via a cross-reference.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:variable name="unpublished-locations" as="element()*">
		<xsl:for-each select="/app/data/locations/location">
			
			<xsl:variable name="locations-within" select="fn:get-locations-within(self::location)" as="element()*" />
			
			<xsl:variable name="references-from-published-entities" as="element()*">
				
				<!-- references from published people -->
				<xsl:sequence select="/app/data/people/person[@publish = 'true']/descendant::location[@ref = (current()/@id, $locations-within/@id)]" />
				
				<!-- references from published events -->
				<xsl:sequence select="/app/data/events/event[not(@id = $unpublished-events/@id)]/descendant::location[@ref = (current()/@id, $locations-within/@id)]" />

				<!-- references from published organisations -->
				<xsl:sequence select="/app/data/organisations/organisation[not(@id = $unpublished-organisations/@id)]/descendant::location[@ref = (current()/@id, $locations-within/@id)]" />

			</xsl:variable>
			
			<xsl:if test="count($references-from-published-entities) = 0">
				<xsl:sequence select="self::*" />
			</xsl:if>
		</xsl:for-each>
	</xsl:variable>
	
	
	
	<doc:doc>
		<doc:title>Initial template</doc:title>
		<doc:desc>
			<doc:p>Match the document root and initiate transformation.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/">
		<xsl:result-document>
			<xsl:apply-templates />
		</xsl:result-document>
	</xsl:template>	

	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress person records that aren't explicitly set to publish.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="person[@id][not(@publish = 'true')]" />	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress references to person records that aren't explicitly set to publish.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="person[@ref]">
		<xsl:choose>
			<xsl:when test="key('person', @ref)">
				<xsl:next-match />
			</xsl:when>
			<xsl:when test="ancestor::note">
				<xsl:choose>
					<xsl:when test="normalize-space(.) = ''">[name witheld]"</xsl:when>
					<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>	

	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress event records that don't invovle a person who isn't explicitly set to publish.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="event[@id]">
		<xsl:if test="not(@id = $unpublished-events/@id)">
			<xsl:next-match />
		</xsl:if>
	</xsl:template>	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress organisation records that don't involve a person who isn't explicitly set to publish</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="organisation[@id]">
		<xsl:if test="not(@id = $unpublished-organisations/@id)">
			<xsl:next-match />
		</xsl:if>
	</xsl:template>	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress location records that don't involve a person who isn't explicitly set to publish.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="location[@id]">
		<xsl:if test="not(@id = $unpublished-locations/@id)">
			<xsl:next-match />
		</xsl:if>
	</xsl:template>	
	
	
	
	<doc:doc>
		<doc:title>Identity Transform: Element</doc:title>
		<doc:desc>
			<doc:p>Match and copy and element node.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Identity Transform: Attribute, Comment or Processing Instruction</doc:title>
		<doc:desc>
			<doc:p>Match and deep copy an attribute, comment or processing instruction.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="@* | comment() | processing-instruction()">
		<xsl:copy-of select="." />
	</xsl:template>
	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Return a list of all the locations within a specified location.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:function name="fn:get-locations-within" as="element()*">
		<xsl:param name="location-in" as="element()" />
		
		<xsl:for-each select="$location-in/key('location-within', @id)">
			<xsl:sequence select="current()" /> 
			<xsl:sequence select="fn:get-locations-within(current())" />
		</xsl:for-each>
		
	</xsl:function>
	
</xsl:stylesheet>
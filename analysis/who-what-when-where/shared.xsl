<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"	
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:void="http://rdfs.org/ns/void#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="xs"
	version="2.0">
	
	<doc:doc>
		<doc:title>Key: Person</doc:title>
		<doc:desc>
			<doc:p>For quickly finding an person entity in the data, using it's ID.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="person" match="/data/people/person" use="@id" />	
	
	<doc:doc>
		<doc:title>Key: Child Locations</doc:title>
		<doc:desc>
			<doc:p>For quickly building a list of all locations within a specified location.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="location" match="/data/locations/location[@id]" use="@id" />
	<xsl:key name="child-locations" match="//location[@id]" use="within/@ref" />
	<xsl:key name="parent-location" match="//location[@id]" use="@id" />
	<xsl:key name="birth" match="//event[@type = 'birth']" use="person/@ref" /> 
	
	
	<xsl:variable name="tree-id" as="xs:string">
		<xsl:apply-templates select="/data/prov:document/prov:wasDerivedFrom" mode="tree-id" />
	</xsl:variable>
	
	<xsl:template match="prov:wasDerivedFrom" mode="tree-id">
		<xsl:variable name="entity-id" select="prov:entity/@prov:ref" as="xs:string" />
		<xsl:choose>
			<xsl:when test="parent::*/prov:entity[prov:wasDerivedFrom]/@prov:id = $entity-id">
				<xsl:apply-templates select="parent::*/prov:entity[@prov:id = $entity-id]/prov:wasDerivedFrom" mode="tree-id" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$entity-id" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	<xsl:template match="/" mode="html-head">
		<xsl:param name="title" as="xs:string?" />
		<head>
			<title><xsl:value-of select="$title" /> (<xsl:value-of select="data/void:dataset/@void:name" />)</title>
			<style><xsl:comment>
				tr.subject > * { background-color: #F5F5F5; font-weight: bold; }
				tr.partner > * { border-top: solid 1px silver; }				
				th, td { padding: .5em; }
				table .gender { text-align: center; }
				table .age { text-align: right; }
				table .birth-year { text-align: center; }
				table .death-year { text-align: center; }
			</xsl:comment></style>
		</head>
	</xsl:template>
	
	<xsl:template match="event" mode="timeline">
		<div class="event">
			<xsl:apply-templates select="date" />
			<span><xsl:value-of select="codepoints-to-string(160)" /></span>
			<xsl:apply-templates select="self::event" mode="summarise" />
		</div>
	</xsl:template>
	
	<xsl:template match="date">
		<xsl:variable name="month-names" select="('Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec')" as="xs:string+" />
		<xsl:variable name="month-name-abbreviated" select="if (@month) then $month-names[position() = current()/@month] else ()" as="xs:string?" />
		<span class="date">
			<xsl:value-of select="string-join(
				(
				@modifier, 
				@year, 
				$month-name-abbreviated, 
				@day
				), 
				' '
				)" />
		</span>
	</xsl:template>
	
	<xsl:template match="date/@type">
		<span class="event-type"><xsl:value-of select="." /></span>
	</xsl:template>
	
	
	
	<doc:doc>
		<doc:title>Event Summary (Content): Birth or Adoption</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for a birth or adoption.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="event[@type = ('birth', 'adoption')][not(summary)]" mode="summarise">
		<xsl:variable name="parents" select="key('birth', person/@ref)/parent/key('person', @ref)" as="element()*" />
		<xsl:variable name="child" select="key('person', person/@ref)" as="element()?" />
		
		<xsl:choose>
			<xsl:when test="count($child) &gt; 0">
				<xsl:apply-templates select="$child" mode="href-html" />
			</xsl:when>
			<xsl:otherwise>A child</xsl:otherwise>
		</xsl:choose>
		<xsl:text> is </xsl:text>
		<xsl:choose>
			<xsl:when test="@type = 'adoption'">adopted</xsl:when>
			<xsl:otherwise>born</xsl:otherwise>
		</xsl:choose>
		<xsl:if test="count($parents) > 0"> 
			<xsl:choose>
				<xsl:when test="@type = 'adoption'"> by </xsl:when>
				<xsl:otherwise> to </xsl:otherwise>
			</xsl:choose>
		</xsl:if>
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
		<doc:title>Event Summary (Content): Marriage</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for a marriage.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="event[@type = 'marriage'][not(summary)]" mode="summarise">
		<xsl:variable name="partners" select="key('person', person/@ref)" as="element()*" />
		<xsl:for-each select="person">
			<xsl:apply-templates select="key('person', @ref)" mode="href-html" />
			<xsl:if test="position() != last()">
				<xsl:text> and </xsl:text>
			</xsl:if>
		</xsl:for-each>		
		<xsl:choose>
			<xsl:when test="count($partners) = 1"> marries.</xsl:when>
			<xsl:otherwise> marry.</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Event Summary (Content): Death</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for a death.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="event[@type = 'death'][not(summary)]" mode="summarise">
		
		<xsl:apply-templates select="key('person', person/@ref)" mode="href-html" />
		<xsl:text> dies</xsl:text>
		
	</xsl:template>
	
	<doc:doc>
		<doc:title>Event Summary (Content): Burial</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for a burial.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="event[@type = 'burial'][not(summary)]" mode="summarise">
		
		<xsl:apply-templates select="key('person', person/@ref)" mode="href-html" />
		<xsl:text> is buried</xsl:text>
		
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Event Summary (Content): Baptism</doc:title>
		<doc:desc>
			<doc:p>Generates a summary for a baptism.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="event[@type = 'christening'][not(summary)]" mode="summarise">
		<xsl:variable name="person-id" select="person/@ref" as="xs:string?" />		
		<xsl:apply-templates select="key('person', person/@ref)" mode="href-html" />
		<xsl:if test="$person-id">
			<xsl:variable name="parents" select="key('birth', person/@ref)/parent/key('person', @ref)" as="element()*" />
			<xsl:if test="$parents"><xsl:text>, child of</xsl:text><xsl:for-each select="$parents">
					<xsl:apply-templates select="current()" mode="href-html" />
					<xsl:if test="position() != last()"> and </xsl:if>
				</xsl:for-each></xsl:if>
		</xsl:if><xsl:text> is baptised</xsl:text>
		
	</xsl:template>
	
	
	<xsl:template match="*[@id]" mode="href-html" priority="100">
		<a href="#{@id}"><xsl:next-match /></a>
	</xsl:template>
	
	<xsl:template match="person" mode="href-html">
		<xsl:apply-templates select="persona[1]" mode="#current" />
	</xsl:template>
	
	<xsl:template match="persona" mode="href-html">
		<a href="https://www.ancestry.co.uk/family-tree/person/tree/{$tree-id}/person/{substring-after(ancestor::person[1]/@id, 'I')}/facts"><xsl:value-of select="string-join(name/*, ' ')" /></a>		
	</xsl:template>
	
	
	<xsl:function name="fn:filter-events-for-partner-events" as="element()*">
		<xsl:param name="events" as="element()*"/>
		
		<xsl:sequence select="$events[@type = 'birth'][count(parent) > 1], $events[@type = 'marriage'][count(person) > 1]" />
		<xsl:sequence select="$events[@type = 'christening']/person/key('birth', @ref)[count(parent) > 1]" />
		
	</xsl:function>	
	
</xsl:stylesheet>
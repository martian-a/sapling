<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:guide="http://ns.thecodeyard.co.uk/data/sapling/annotations/guide"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" />  
	
	<xsl:template match="people/person">
		<xsl:variable name="person-id" select="@id" as="xs:string" />
		<xsl:variable name="partner-events" as="element()*">
			<xsl:for-each select="/data/events/event[(@type = ('marriage', 'divorce') and person/@ref = $person-id) or (@type = 'birth' and parent/@ref = $person-id)][not(@*:status = 'alternative')]">
				<xsl:sort select="date/@year/xs:integer(.)" data-type="number" order="ascending" />
				<xsl:sequence select="self::*" />
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="origin-events" as="element()*">
			<xsl:for-each select="/data/events/event[@type = ('birth', 'christening')][not(@*:status = 'alternative')][person/@ref = $person-id]">
				<xsl:sort select="date/@year/xs:integer(.)" data-type="number" order="ascending" />
				<xsl:sequence select="self::*" />
			</xsl:for-each>
		</xsl:variable>
		<xsl:variable name="cessation-events" as="element()*">
			<xsl:for-each select="/data/events/event[@type = ('death', 'burial')][not(@*:status = 'alternative')][person/@ref = $person-id]">
				<xsl:sort select="date/@year/xs:integer(.)" data-type="number" order="ascending" />
				<xsl:sequence select="self::*" />
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:variable name="birth-year" as="xs:integer?" select="(
			$origin-events[1]/date/@year,
			($partner-events[1]/date/@year/number(.) - 14)
			)[1] ! xs:integer(.)" />
		
		<xsl:variable name="birth-location-id" as="xs:string?" select="(
			$origin-events[1]/location/@ref,
			$partner-events[1]/location/@ref
			)[1]" />		
		
		<xsl:variable name="death-year" as="xs:integer?" select="(
				$cessation-events[position() = last()]/date/@year			
			)[1] ! xs:integer(.)" />
				
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:if test="$birth-year">
				<xsl:attribute name="year" select="$birth-year" />
				<xsl:attribute name="guide:birth-year" select="$birth-year" />
			</xsl:if>	
			<xsl:if test="$death-year">
				<xsl:attribute name="guide:death-year" select="$death-year" />
			</xsl:if>				
			<xsl:if test="$birth-location-id">
				<xsl:attribute name="guide:birth-location-id" select="$birth-location-id" />
			</xsl:if>					
			<xsl:apply-templates />			
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="people/person/persona[1]">
		<xsl:for-each-group select="parent::person/persona" group-by="string-join((string-join(name/*, ' '), distinct-values(gender)), '#')">
			<xsl:for-each select="current-group()[1]">
				<xsl:copy>
					<xsl:apply-templates select="@*" />
					<xsl:for-each-group select="node()" group-by="name()">
						<xsl:apply-templates select="current-group()[1]" />
					</xsl:for-each-group>
				</xsl:copy>
			</xsl:for-each>
		</xsl:for-each-group>
	</xsl:template>
    
    <xsl:template match="people/person/persona[position() != 1]" />
    
    <xsl:include href="../../../../utils/identity.xsl" />
    
</xsl:stylesheet>
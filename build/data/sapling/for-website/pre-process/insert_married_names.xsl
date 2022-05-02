<?xml-model href="http://ns.thecodeyard.co.uk/schema/cinnamon.sch?v=0.1.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" 
    version="2.0">
    
    
    <doc:doc scope="stylesheet">
        <doc:title>Married Names</doc:title>
        <doc:desc>Generate and append personas for married names.</doc:desc>
    </doc:doc>
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes" />
    
    <xsl:include href="../../../../utils/identity.xsl" />
    
    <xsl:key name="marriages" match="/app/data/events/event[@type = 'marriage']" use="person/@ref" />
    <xsl:key name="person" match="/app/data/people/person" use="@id" />
    
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>


    <doc:doc>
        <doc:desc>Select the last persona.</doc:desc>
    </doc:doc>
    <xsl:template match="data/people/person/persona[not(following-sibling::persona)]" priority="10">
        <xsl:next-match />
        <xsl:apply-templates select="parent::person[persona/gender/lower-case(.) = 'female']" mode="married-names" />
    </xsl:template>
    
    
    <xsl:template match="person[@id]" mode="married-names">
        <xsl:variable name="forenames" select="persona[1]/name/name[not(@family = 'yes')]" />
        <xsl:variable name="gender" select="persona[1]/gender" />
        <xsl:variable name="marriages" select="key('marriages', @id)" as="element()*" />
        <xsl:variable name="partners" select="$marriages/person[@ref != current()/@id]/key('person', @ref)" />
        <xsl:for-each-group select="$partners[persona/name/name/@family = 'yes']" group-by="@id">
            <persona>
                <name>
                    <xsl:copy-of select="$forenames" />
                    <xsl:copy-of select="current-group()[1]/persona[name/name/@family = 'yes'][1]/name/name[@family = 'yes']" />
                </name>
                <xsl:copy-of select="$gender" />
            </persona>
        </xsl:for-each-group>
    </xsl:template>
    
    
  
</xsl:stylesheet>
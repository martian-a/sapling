<?xml-model href="http://ns.thecodeyard.co.uk/schema/cinnamon.sch?v=0.1.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" 
    version="2.0">
    
    
    <doc:doc scope="stylesheet">
        <doc:title>Century Entities</doc:title>
        <doc:desc>Group events by century.</doc:desc>
    </doc:doc>
    
    
    <xsl:include href="../utils/identity.xsl" />
    
    
    <xsl:template match="/">
        <centuries>
            <xsl:apply-templates select="/app/data/events" />
        </centuries>
    </xsl:template>
    
    
    <xsl:template match="/app/data/events" priority="10">
        <xsl:for-each-group select="event" group-by="normalize-space(date/@year) = ''">
            <xsl:choose>
                <xsl:when test="current-grouping-key() = true()">
                    <xsl:call-template name="build-century-entity">
                        <xsl:with-param name="id-part" select="0" as="xs:integer" />
                        <xsl:with-param name="start" select="0" as="xs:integer" />                        
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each-group select="current-group()" group-by="xs:integer(floor(date/@year div 100))">
                        <xsl:call-template name="build-century-entity">
                            <xsl:with-param name="id-part" select="current-grouping-key() + 1" as="xs:integer" />
                            <xsl:with-param name="start" select="current-grouping-key() * 100" as="xs:integer" />
                        </xsl:call-template>                    
                    </xsl:for-each-group>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>
    
    
    <xsl:template name="build-century-entity">
        <xsl:param name="id-part" as="xs:integer" />
        <xsl:param name="start" as="xs:integer" />
        
        
            <century id="CEN{$id-part}">
                <xsl:if test="$id-part != 0">
                    <xsl:attribute name="start" select="$start" />
                </xsl:if>
                <xsl:apply-templates select="current-group()">
                    <xsl:sort select="date/@year" data-type="number" order="ascending" />
                    <xsl:sort select="date/@month" data-type="number" order="ascending" />
                    <xsl:sort select="date/@day" data-type="number" order="ascending" />
                    <xsl:sort select="@id" data-type="text" order="ascending" />
                </xsl:apply-templates>
            </century>

    </xsl:template>
    
    <xsl:template match="/app/data/events/event">
        <xsl:copy>
            <xsl:attribute name="ref" select="@id" />
        </xsl:copy>
    </xsl:template>

    
</xsl:stylesheet>
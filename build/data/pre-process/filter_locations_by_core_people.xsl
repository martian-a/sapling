<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:include href="../../utils/identity.xsl" />
    
    <xsl:output encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />
    
    <xsl:key name="location" match="/app/data/locations/location" use="@id" />
   
    <xsl:template match="/">
        <xsl:result-document>
            <xsl:apply-templates />
        </xsl:result-document>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>
            <doc:p>Suppress location records that don't involve a person, event or organisation that's due to be published.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="data/locations">
    
        <xsl:variable name="referenced-locations" as="element()*">
            
            <!-- Core locations -->
            <xsl:variable name="referenced-from-core-entities" as="element()*">
                <xsl:apply-templates select="location" mode="direct-reference" />
            </xsl:variable>  
            
            <!-- Other locations that core locations have a dependency on. -->
            <xsl:variable name="referenced-from-core-locations" as="element()*">
                <xsl:apply-templates select="$referenced-from-core-entities" mode="indirect-reference" />
            </xsl:variable>
            
            <xsl:for-each-group select="$referenced-from-core-entities | $referenced-from-core-locations" group-by="@id">
                <xsl:sort select="number(translate(current-grouping-key(), 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', ''))" data-type="number" order="ascending" />
                <xsl:sequence select="current-group()[1]" />
            </xsl:for-each-group>
            
        </xsl:variable>
    
        
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            
            <!-- Merge and de-dupe the collections of core locations and their dependencies. -->
            <xsl:apply-templates select="location[@id = $referenced-locations/@id]" />
            
        </xsl:copy>
        
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>
            <doc:p>Filter out location records that don't involve a person, event or organisation that's due to be published.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="location" mode="direct-reference">
        <xsl:variable name="references-from-core-people" select="/app/data/people/person/descendant::location[@ref = current()/@id]" />
        <xsl:variable name="references-from-core-events" select="/app/data/events/event/descendant::location[@ref = current()/@id]" />
        <xsl:variable name="references-from-core-organisations" select="/app/data/organisations/organisation/descendant::location[@ref = current()/@id]" />
        
        <xsl:if test="count($references-from-core-people | $references-from-core-events | $references-from-core-organisations) &gt; 0">
            <xsl:sequence select="self::*" />
        </xsl:if>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>
            <doc:p>Add back in a location record that is indirectly referenced by a core location.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="location[@id]" mode="indirect-reference">
        <xsl:param name="already-referenced" as="element()*" tunnel="yes" />
      
        <xsl:variable name="updated-already-referenced" as="element()*">
            <xsl:copy-of select="$already-referenced" />
            <xsl:copy-of select="self::location" />
        </xsl:variable>
      
        <xsl:copy-of select="self::location" />
        <xsl:apply-templates select="descendant::*[@ref[not(. = $updated-already-referenced/@id)] = /app/data/locations/location/@id]" mode="#current">
            <xsl:with-param name="already-referenced" select="$updated-already-referenced" as="element()*" tunnel="yes" />
        </xsl:apply-templates>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>
            <doc:p>Match references to locations. Includes near, within, etc. as well as location/@ref.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="*[@ref]" mode="indirect-reference">        
        <xsl:apply-templates select="key('location', @ref)" mode="#current" />
    </xsl:template>
    
</xsl:stylesheet>
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
    
   
    <xsl:template match="/">
        <xsl:result-document>
            <xsl:apply-templates />
        </xsl:result-document>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>
            <doc:p>Filter entities by whether they are referenced by an entity that is due to be published.</doc:p>
        </doc:desc>
        <doc:note>
            <doc:p>Sources that don't involve an entity that is due to be published should be kept in the temporary collection (exclude) in case they need to be added back in later in the pre-process.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="/app/data" priority="10">
                    
        <xsl:next-match>
            <xsl:with-param name="include" as="element()*" tunnel="yes">
                <xsl:apply-templates select="exclude/*/*" mode="filter" />
                <xsl:sequence select="exclude/static-content/*" />
            </xsl:with-param>
            <xsl:with-param name="collection-names" as="xs:string*" tunnel="yes">
                <xsl:for-each-group select="*/*" group-by="name()">
                    <xsl:value-of select="current-grouping-key()" />
                </xsl:for-each-group>
            </xsl:with-param>
        </xsl:next-match>        
            
    </xsl:template>
    
        
    <doc:doc>
        <doc:desc>
            <doc:p>Select an excluded entity (other than an event) that is referenced by an entity that's currently due to be published.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="*[name() != 'event'][@id]" mode="filter">
        
        <xsl:variable name="references-from-core-entities" select="/app/data/include/descendant::*[@ref = current()/@id]" />
        
        <xsl:if test="count($references-from-core-entities) &gt; 0">
            <xsl:sequence select="self::*" />
        </xsl:if>
    </xsl:template>	
    
    <doc:doc>
        <doc:desc>
            <doc:p>Select an excluded event that is references a person that's currently due to be published.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="event[@id]" mode="filter">
        
        <xsl:variable name="references-to-core-people" select="/app/data/include/people/person[@id = current()/descendant::*/@ref]" />
        
        <xsl:if test="count($references-to-core-people) &gt; 0">
            <xsl:sequence select="self::*" />
        </xsl:if>
    </xsl:template>	
    
    
    <doc:doc>
        <doc:desc>
            <doc:p>Move into the include collection all currently excluded entities that involve an entity that is currently due to be published.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="/app/data/include">
        <xsl:param name="include" as="element()*" tunnel="yes" />
        <xsl:param name="collection-names" as="xs:string*" tunnel="yes" />
        
        <xsl:variable name="already-included" select="self::*" as="element()" />

        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:for-each select="$collection-names">
                <xsl:element name="{.}">
                    <xsl:apply-templates select="$already-included/*[name() = current()]/@*" />
                    <xsl:apply-templates select="$already-included/*[name() = current()]/*" />
                    <xsl:copy-of select="$include[parent::*/name() = current()]" />
                </xsl:element>
            </xsl:for-each>            
        </xsl:copy>
        
    </xsl:template>	
    
    
    <doc:doc>
        <doc:desc>
            <doc:p>Remove from the exclude collection all organisations that have been moved into the include collection.</doc:p>
        </doc:desc>
    </doc:doc>
    <xsl:template match="/app/data/exclude/*/*" priority="10">
        <xsl:param name="include" as="element()*" tunnel="yes" />
        
        <xsl:if test="not(@id = $include/@id)">
            <xsl:next-match />
        </xsl:if>
        
    </xsl:template>    
    
</xsl:stylesheet>
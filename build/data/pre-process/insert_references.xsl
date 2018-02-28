<?xml-model href="http://ns.thecodeyard.co.uk/schema/cinnamon.sch?v=0.1.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all" 
    version="2.0">
    
    
    <doc:doc scope="stylesheet">
        <doc:title>Bibliographic References</doc:title>
        <doc:desc>For each source, generate and append references, created from existing components but structured and ordered as per the reference's style requirements.</doc:desc>
    </doc:doc>
    
    
    <xsl:include href="../../utils/identity.xsl" />
    
    
    <xsl:template match="/">
        <xsl:apply-templates />
    </xsl:template>
    

    <xsl:template match="data/sources/source" mode="bibliography.structure" priority="100">
        <reference type="bibliographic">
            <xsl:next-match />
        </reference>
    </xsl:template>


    <xsl:template match="data/sources/source">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="self::source" mode="bibliography.structure" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a non-serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter[not(serial)]]" mode="bibliography.structure">
        <xsl:attribute name="style">book</xsl:attribute>
        <xsl:apply-templates select="front-matter[author]" mode="bibliography.structure.creators" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.title" />
        <xsl:apply-templates select="front-matter[series]" mode="bibliography.structure.series" />
        <xsl:apply-templates select="front-matter[location]" mode="bibliography.structure.location" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.publisher" />
        <xsl:apply-templates select="front-matter[date/@rel = ('published', 'revised')]" mode="bibliography.structure.date" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter/serial/@type = 'journal']" mode="bibliography.structure">
        <xsl:attribute name="style">journal</xsl:attribute>
        <xsl:apply-templates select="front-matter[author]" mode="bibliography.structure.creators" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.article.title" />
        <journal>
            <xsl:apply-templates select="front-matter/serial[title]" mode="bibliography.structure.serial.title" />
            <xsl:apply-templates select="front-matter/serial/issue[volume or issue or date]" mode="bibliography.structure.serial.issue" />
            <xsl:apply-templates select="front-matter/serial/issue[pages]" mode="bibliography.structure.serial.pages" />
        </journal>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a map.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter/map]" mode="bibliography.structure">
        <xsl:attribute name="style">map</xsl:attribute>
        <xsl:apply-templates select="front-matter[author or map/author]" mode="bibliography.structure.creators" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.map" />
        <map>
            <xsl:apply-templates select="front-matter/map/scale" mode="bibliography.structure.map" />
            <xsl:apply-templates select="front-matter[series]" mode="bibliography.structure.series" />
        </map>
        <xsl:apply-templates select="front-matter[location]" mode="bibliography.structure.location" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.publisher" />
        <xsl:apply-templates select="front-matter[date/@rel = ('published', 'revised')]" mode="bibliography.structure.date" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a generic serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter/serial/@type/normalize-space(.) = '']" mode="bibliography.structure">
        <xsl:attribute name="style">generic-serial</xsl:attribute>
        <xsl:apply-templates select="front-matter[descendant::author]" mode="bibliography.structure.creators" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.title" />
        <xsl:apply-templates select="front-matter[series or serial/title]" mode="bibliography.structure.series" />
        <xsl:apply-templates select="front-matter[descendant::location]" mode="bibliography.structure.location" />
        <xsl:apply-templates select="front-matter[descendant::publisher]" mode="bibliography.structure.publisher" />
        <xsl:apply-templates select="front-matter[descendant::date/@rel = ('published', 'revised')]" mode="bibliography.structure.date" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add authors into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.creators">
        
        <xsl:variable name="authors" select="descendant::author" as="element()*" />
        
        <creators>
            <xsl:choose>
                <xsl:when test="count($authors) &gt; 5">
                    <xsl:apply-templates select="$authors[1]" mode="bibliography.structure.creators.et-al" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$authors" mode="#current" />
                </xsl:otherwise>
            </xsl:choose>
        </creators>
        
    </xsl:template>
    
    
    <xsl:template match="author" mode="bibliography.structure.creators.et-al">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="et-al">true</xsl:attribute>
            <xsl:apply-templates select="name" mode="bibliography.structure.creators" />
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="author" mode="bibliography.structure.creators">
        <xsl:copy>
            <xsl:apply-templates select="@*, name" mode="#current" />
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="author/name" mode="bibliography.structure.creators">
        <xsl:choose>
            <xsl:when test="position() = 1">
                <xsl:copy>
                    <xsl:copy-of select="@*" />
                    <xsl:apply-templates select="name[@family = 'yes']" />
                    <xsl:apply-templates select="node()[not(self::name/@family = 'yes')]" />
                </xsl:copy> 
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="self::*" />
            </xsl:otherwise>
        </xsl:choose>              
    </xsl:template>
    
    
    
    <doc:doc>
        <doc:desc>Add the source title into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.title bibliography.structure.article.title bibliography.structure.map">
        
        <titles>
            <xsl:choose>
                <xsl:when test="title">
                    <xsl:apply-templates select="self::*" mode="bibliography.structure.language">
                        <xsl:with-param name="element-name" as="xs:string">title</xsl:with-param>
                    </xsl:apply-templates>                    
                </xsl:when>
                <xsl:otherwise>
                    <title status="inferred">Untitled</title>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="self::*" mode="bibliography.structure.language">
                <xsl:with-param name="element-name" as="xs:string">subtitle</xsl:with-param>
            </xsl:apply-templates>
            <xsl:apply-templates select="map/sheet" mode="#current" />
        </titles>
        
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add a map sheet number into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter/map/sheet | source/front-matter/map/scale" mode="bibliography.structure.map">
        <xsl:copy-of select="self::*" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the series title into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.series">
        
        <xsl:apply-templates select="self::*" mode="bibliography.structure.language">
            <xsl:with-param name="element-name" as="xs:string">series</xsl:with-param>
        </xsl:apply-templates>
        
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>If there may be more than one option, potentially in more than one language, select just one.</doc:desc>
        <doc:note>Currently defaults to the first in English.</doc:note>
    </doc:doc>
    <xsl:template match="*" mode="bibliography.structure.language">
        <xsl:param name="element-name" as="xs:string" />
        
        <xsl:choose>
            <xsl:when test="*[name() = $element-name][@xml:lang = 'en']">
                <xsl:apply-templates select="*[name() = $element-name][@xml:lang = 'en'][1]" mode="bibliography.structure.language.small-words" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*[name() = $element-name][not(@xml:lang)][1]" mode="bibliography.structure.language.small-words" />
            </xsl:otherwise>
        </xsl:choose>
        
    </xsl:template>
    
    
    <xsl:template match="*" mode="bibliography.structure.language.small-words">
        <xsl:copy-of select="self::*" />
    </xsl:template>
    
    
    <xsl:template match="source/front-matter/serial/title" mode="bibliography.structure.language.small-words">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:for-each select="tokenize(., ' ')">
                <xsl:choose>
                    <xsl:when test="position() = 1 and lower-case(.) = ('the', 'a', 'an')" />
                    <xsl:otherwise>
                        <xsl:value-of select="." />
                        <xsl:if test="position() != last()">
                            <xsl:text> </xsl:text>
                        </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                
            </xsl:for-each>
        </xsl:copy>
    </xsl:template>
    
    <doc:doc>
        <doc:desc>Add the publication location into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.location">
        <xsl:copy-of select="location" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the publisher into the structure of a bibliographic reference.</doc:desc>
        <doc:note>
            <doc:p>If necessary, "n.p." is used to indicate that the publisher is not known.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.publisher">
        <xsl:choose>
            <xsl:when test="publisher">
                <xsl:copy-of select="publisher" />
            </xsl:when>
            <xsl:otherwise>
                <publisher>n.p.</publisher>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the publication date(s) into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.date">
        <xsl:copy-of select="date[@rel = 'published'][1]" />
        <xsl:copy-of select="date[@rel = 'revised'][1]" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial title into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter/serial" mode="bibliography.structure.serial.title">
        <xsl:apply-templates select="self::*" mode="bibliography.structure.language">
            <xsl:with-param name="element-name" as="xs:string">title</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial volume and/or issue into the structure of a bibliographic reference for a serial.</doc:desc>
        <doc:note>
            <doc:p>See separate template for newspapers.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="front-matter/serial/issue" mode="bibliography.structure.serial.issue" priority="10">
        <issue>
            <xsl:next-match />
        </issue>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial volume and/or issue into the structure of a bibliographic reference for a serial.</doc:desc>
        <doc:note>
            <doc:p>See separate template for newspapers.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="front-matter/serial[not(@type)]/issue" mode="bibliography.structure.serial.issue">
        <xsl:copy-of select="volume" />
        <xsl:copy-of select="issue" />
        <xsl:copy-of select="date" />
    </xsl:template>
    
    <doc:doc>
        <doc:desc>Add the date into the structure of a bibliographic reference for a newspaper.</doc:desc>
    </doc:doc>
    <xsl:template match="front-matter/serial[@type = 'newspaper']/issue" mode="bibliography.structure.serial.issue">
        <xsl:copy-of select="date" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial volume and/or issue into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="front-matter/serial/issue" mode="bibliography.structure.serial.pages">
        <xsl:copy-of select="pages" />
    </xsl:template>
    
    
</xsl:stylesheet>
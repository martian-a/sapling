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
    
    
    <xsl:template match="data/sources/source">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="self::source" mode="bibliography.structure" />
            <xsl:apply-templates select="node()" />
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="data/sources/source" mode="bibliography.structure" priority="100">
        <reference type="bibliographic">
            <xsl:next-match />
        </reference>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a non-serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter/not(journal)]" mode="bibliography.structure">
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
    <xsl:template match="source[front-matter/journal]" mode="bibliography.structure">
        <xsl:attribute name="style" select="if (front-matter/journal/@type) then front-matter/journal/@type else 'journal'" />
        <xsl:apply-templates select="front-matter[author]" mode="bibliography.structure.creators" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.article.title" />
        <journal>
            <xsl:apply-templates select="front-matter/journal[title]" mode="bibliography.structure.journal.title" />
            <xsl:apply-templates select="front-matter/journal/issue[volume or issue or date]" mode="bibliography.structure.journal.issue" />
            <xsl:apply-templates select="front-matter/journal/issue[pages]" mode="bibliography.structure.journal.pages" />
        </journal>
    </xsl:template>
    
    
    
    
    <doc:doc>
        <doc:desc>Add authors into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.creators">
        
        <creators>
            <xsl:choose>
                <xsl:when test="count(author) &gt; 5">
                    <xsl:apply-templates select="author[1]" mode="bibliography.structure.creators.et-al" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="author" />
                </xsl:otherwise>
            </xsl:choose>
        </creators>
        
    </xsl:template>
    
    
    <xsl:template match="source/front-matter/author[count(preceding-sibling::author) = 0]" mode="bibliography.structure.creators.et-al">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="et-al">true</xsl:attribute>
            <xsl:apply-templates select="name" />
        </xsl:copy>
    </xsl:template>
    
    
    <xsl:template match="source/front-matter/author[count(preceding-sibling::author) = 0]/name">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates select="name[@family = 'yes']" />
            <xsl:apply-templates select="node()[not(self::name/@family = 'yes')]" />
        </xsl:copy>       
    </xsl:template>
    
    
    
    <doc:doc>
        <doc:desc>Add the source title into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.title bibliography.structure.article.title">
        
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
        </titles>
        
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
        <xsl:param name="element-name" select="xs:string" />
        
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
    
    
    <xsl:template match="source/front-matter/journal/title" mode="bibliography.structure.language.small-words">
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
        <doc:desc>Add the journal title into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter/journal" mode="bibliography.structure.journal.title">
        <xsl:apply-templates select="self::*" mode="bibliography.structure.language">
            <xsl:with-param name="element-name" as="xs:string">title</xsl:with-param>
        </xsl:apply-templates>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial volume and/or issue into the structure of a bibliographic reference for a journal.</doc:desc>
        <doc:note>
            <doc:p>See separate template for newspapers.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="front-matter/journal/issue" mode="bibliography.structure.journal.issue" priority="10">
        <issue>
            <xsl:next-match />
        </issue>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial volume and/or issue into the structure of a bibliographic reference for a journal.</doc:desc>
        <doc:note>
            <doc:p>See separate template for newspapers.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="front-matter/journal[not(@type)]/issue" mode="bibliography.structure.journal.issue">
        <xsl:copy-of select="volume" />
        <xsl:copy-of select="issue" />
        <xsl:copy-of select="date" />
    </xsl:template>
    
    <doc:doc>
        <doc:desc>Add the date into the structure of a bibliographic reference for a newspaper.</doc:desc>
    </doc:doc>
    <xsl:template match="front-matter/journal[@type = 'newspaper']/issue" mode="bibliography.structure.journal.issue">
        <xsl:copy-of select="date" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial volume and/or issue into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="front-matter/journal/issue" mode="bibliography.structure.journal.pages">
        <xsl:copy-of select="pages" />
    </xsl:template>
    
    
</xsl:stylesheet>
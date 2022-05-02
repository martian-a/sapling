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
    
    <xsl:output encoding="UTF-8" method="xml" indent="yes" />
    
    <xsl:include href="../../../../utils/identity.xsl" />
    
    
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
    
    
    <xsl:variable name="contributor-roles" select="'author', 'editor', 'contributor'" as="xs:string*" />
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a non-serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter[not(serial) and not(map)]]" mode="bibliography.structure">
        <xsl:attribute name="style">book</xsl:attribute>
        <xsl:apply-templates select="front-matter[descendant::*/name() = $contributor-roles]" mode="bibliography.structure.contributors" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.title" />
        <xsl:apply-templates select="front-matter[series]" mode="bibliography.structure.series" />
        <xsl:apply-templates select="front-matter[location or publisher or date/@rel = ('published', 'revised')]" mode="bibliography.structure.publication" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a non-serial source.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter[serial/not(@type)]]" mode="bibliography.structure">
        <xsl:attribute name="style">book</xsl:attribute>
        <xsl:apply-templates select="front-matter[descendant::*/name() = $contributor-roles]" mode="bibliography.structure.contributors" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.title" />
        <xsl:apply-templates select="front-matter[series or serial[title or part/volume]]" mode="bibliography.structure.series" />
        <xsl:apply-templates select="front-matter[descendant::location or descendant::publisher or descendant::date/@rel = ('published', 'revised')]" mode="bibliography.structure.publication" />
        <xsl:apply-templates select="front-matter/descendant::pages" mode="bibliography.structure.serial.pages" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a newspaper.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter/serial/@type = 'newspaper']" mode="bibliography.structure">
        <xsl:attribute name="style">newspaper</xsl:attribute>
        <xsl:apply-templates select="front-matter[descendant::*/name() = $contributor-roles]" mode="bibliography.structure.contributors" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.article.title" />
        <publication>
            <xsl:apply-templates select="front-matter/serial[title]" mode="bibliography.structure.serial.title" />
            <xsl:apply-templates select="front-matter/serial/part[date/@rel = ('issue', 'published')]" mode="bibliography.structure.serial.part" />
            <xsl:apply-templates select="front-matter/descendant::pages" mode="bibliography.structure.serial.pages" />
        </publication>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a journal source.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter/serial/@type = 'journal']" mode="bibliography.structure">
        <xsl:attribute name="style">journal</xsl:attribute>
        <xsl:apply-templates select="front-matter[descendant::*/name() = $contributor-roles]" mode="bibliography.structure.contributors" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.article.title" />
        <publication>
            <xsl:apply-templates select="front-matter/serial[title]" mode="bibliography.structure.serial.title" />
            <xsl:apply-templates select="front-matter/serial/part[volume or issue or date]" mode="bibliography.structure.serial.part" />
            <xsl:apply-templates select="front-matter/descendant::pages" mode="bibliography.structure.serial.pages" />
        </publication>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a death certificate.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter/serial/@type = 'death-certificate']" mode="bibliography.structure">
        <xsl:attribute name="style">death-certificate</xsl:attribute>
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.title" />
        <xsl:apply-templates select="front-matter/serial[publisher or location or volume or issue or date[@rel = 'issue']]" mode="bibliography.structure.publication" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Select and structure the components required for a bibliographic entry for a map.</doc:desc>
    </doc:doc>
    <xsl:template match="source[front-matter[serial/@type = 'map' or map]]" mode="bibliography.structure">
        <xsl:attribute name="style">map</xsl:attribute>
        <xsl:apply-templates select="front-matter[descendant::*/name() = $contributor-roles]" mode="bibliography.structure.contributors" />
        <xsl:apply-templates select="front-matter" mode="bibliography.structure.article.title" />
        <xsl:apply-templates select="front-matter/descendant::scale" mode="bibliography.structure.map.scale" />
        <xsl:apply-templates select="front-matter[serial[@type = 'map']/title or map/title or descendant::sheet]" mode="bibliography.structure.map.series" />                 
        <publication>
            <xsl:apply-templates select="front-matter/descendant::date[@rel = ('published', 'revised')]" mode="bibliography.structure.date.year-only" />    
        </publication>
    </xsl:template>
    
    
    <xsl:template match="source/front-matter" mode="bibliography.structure.map.series">
        <series>            
            <xsl:apply-templates select="*[name() = ('serial', 'map')]/title" mode="bibliography.map.series.title" />
            <xsl:apply-templates select="descendant::sheet" mode="bibliography.structure.map" />
        </series>
    </xsl:template>
    
    
    <xsl:template match="*[name() = ('serial', 'map')][@type = 'map']/title" mode="bibliography.map.series.title">
        <xsl:copy-of select="self::*" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add authors into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.contributors">
        
        <xsl:variable name="contributors" select="descendant::*[name() = $contributor-roles]" as="element()*" />
        
        <contributors>
            <xsl:choose>
                <xsl:when test="count($contributors) &gt; 5">
                    <xsl:apply-templates select="$contributors[1]" mode="bibliography.structure.contributors.et-al" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates select="$contributors" mode="#current" />
                </xsl:otherwise>
            </xsl:choose>
        </contributors>
        
    </xsl:template>
    
    
    <xsl:template match="*[name() = $contributor-roles]" mode="bibliography.structure.contributors.et-al">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:attribute name="et-al">true</xsl:attribute>
            <xsl:choose>
                <xsl:when test="name">
                    <xsl:apply-templates mode="person.name.formal-style" />
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates mode="contributor.name.natural-order" />
                </xsl:otherwise>
            </xsl:choose>
            
        </xsl:copy>
    </xsl:template>
    
    
    
    <xsl:template match="*[name() = $contributor-roles]" mode="bibliography.structure.contributors" priority="10">
        <xsl:copy>
            <xsl:apply-templates select="@*" mode="#current" />
            <xsl:next-match />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="*[name() = $contributor-roles][name]" mode="bibliography.structure.contributors">
        <xsl:choose>
            <xsl:when test="position() = 1">
                <xsl:apply-templates select="name" mode="person.name.formal-style" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="name" mode="contributor.name.natural-order" />                    
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="*[name() = $contributor-roles][not(name)]" mode="bibliography.structure.contributors">        
        <xsl:apply-templates select="*" mode="contributor.name.natural-order" />                    
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add a person's name into the structure of a bibliographic reference, with the family name first (formal style).</doc:desc>
    </doc:doc>
    <xsl:template match="*[name() = $contributor-roles]/*" mode="person.name.formal-style">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates select="name[@family = 'yes']" />
            <xsl:apply-templates select="node()[not(self::name/@family = 'yes')]" />
        </xsl:copy>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Copy a person's name into the structure of a bibliographic reference, preserving the natural order.</doc:desc>
    </doc:doc>
    <xsl:template match="*[name() = $contributor-roles]/*" mode="contributor.name.natural-order">
        <xsl:copy>
            <xsl:copy-of select="@*, node()" />
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
                <xsl:when test="serial[not(@type) or @type = 'book']">
                    <xsl:apply-templates select="serial" mode="bibliography.structure.language">
                        <xsl:with-param name="element-name" as="xs:string">title</xsl:with-param>
                    </xsl:apply-templates>   
                </xsl:when>
                <xsl:when test="map">
                    <xsl:apply-templates select="map" mode="bibliography.structure.language">
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
        <doc:desc>Add a map sheet number into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="scale" mode="bibliography.structure.map.scale">
        <xsl:copy-of select="self::*" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Convert a map sheet number into a volume number.</doc:desc>
    </doc:doc>
    <xsl:template match="sheet" mode="bibliography.structure.map">
        <xsl:element name="volume">
            <xsl:apply-templates select="@*, node()" />
        </xsl:element>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the series title and sequence number into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.series" priority="10">        
        <series>
           <xsl:next-match />
        </series>        
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the series title and sequence number into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter[series]" mode="bibliography.structure.series">
        <xsl:apply-templates select="series[title]" mode="bibliography.structure.language">
            <xsl:with-param name="element-name" as="xs:string">title</xsl:with-param>
        </xsl:apply-templates>
        <xsl:copy-of select="series/volume" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the series title and sequence number into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter[not(series)][serial/normalize-space(@type) = '']" mode="bibliography.structure.series">
        <xsl:apply-templates select="serial[title]" mode="bibliography.structure.language">
            <xsl:with-param name="element-name" as="xs:string">title</xsl:with-param>
        </xsl:apply-templates>
        <xsl:copy-of select="serial/part/volume" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the publication details into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.publication">
        
        <publication>
            <xsl:apply-templates select="descendant::location" mode="bibliography.structure.location" />
            <xsl:apply-templates select="self::front-matter" mode="bibliography.structure.publisher" />
            <xsl:apply-templates select="descendant::date[@rel = 'published'][@year]" mode="bibliography.structure.date.year-only" />
        </publication>
        
    </xsl:template>
    
    <doc:doc>
        <doc:desc>Add the publication details into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="source/front-matter/serial[@type = 'death-certificate']" mode="bibliography.structure.publication">
        
        <publication>
            <xsl:apply-templates select="descendant::location" mode="bibliography.structure.location" />
            <xsl:apply-templates select="parent::front-matter" mode="bibliography.structure.publisher" />
            <xsl:apply-templates select="part[volume or issue or date[@rel = 'issue']]" mode="bibliography.structure.serial.part" />
        </publication>
        
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the publication location into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="location[ancestor::front-matter/parent::source]" mode="bibliography.structure.location">
        <xsl:copy-of select="self::*" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the publisher into the structure of a bibliographic reference.</doc:desc>
        <doc:note>
            <doc:p>If necessary, "n.p." is used to indicate that the publisher is not known.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="source/front-matter" mode="bibliography.structure.publisher">
        <xsl:choose>
            <xsl:when test="descendant::publisher">
                <xsl:copy-of select="descendant::publisher" />
            </xsl:when>
            <xsl:otherwise>
                <publisher>n.p.</publisher>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the publication date(s) into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="date[ancestor::front-matter/parent::source]" mode="bibliography.structure.date">
        <xsl:copy-of select="self::*" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the publication date(s) into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="date[ancestor::front-matter/parent::source]" mode="bibliography.structure.date.year-only">
        <xsl:copy>
            <xsl:copy-of select="@rel, @year" />
        </xsl:copy>
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
    
    
    <xsl:template match="*[name() != 'title']" mode="bibliography.structure.language.small-words">
        <xsl:copy-of select="self::*" />
    </xsl:template>
    
    
    <xsl:template match="title" mode="bibliography.structure.language.small-words">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:for-each select="tokenize(., ' ')">
                <xsl:choose>
                    <xsl:when test="position() = 1 and lower-case(.) = ('the', 'a', 'an')">
                        <small><xsl:value-of select="." /></small>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="." />
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="position() != last()">
                    <xsl:text> </xsl:text>
                </xsl:if>                
            </xsl:for-each>
        </xsl:copy>
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
    <xsl:template match="front-matter/serial/part" mode="bibliography.structure.serial.part" priority="10">
        <xsl:copy>
            <xsl:next-match />
        </xsl:copy>
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial volume and/or issue into the structure of a bibliographic reference for a serial.</doc:desc>
        <doc:note>
            <doc:p>See separate template for newspapers.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="front-matter/serial[not(@type) or @type = 'journal']/part" mode="bibliography.structure.serial.part">
        <xsl:copy-of select="volume" />
        <xsl:copy-of select="issue" />
        <xsl:copy-of select="date" />
    </xsl:template>
    
    <doc:doc>
        <doc:desc>Add the date into the structure of a bibliographic reference for a newspaper.</doc:desc>
    </doc:doc>
    <xsl:template match="front-matter/serial[@type = 'newspaper']/part" mode="bibliography.structure.serial.part">
        <xsl:copy-of select="date" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial volume and/or issue into the structure of a bibliographic reference for a serial.</doc:desc>
        <doc:note>
            <doc:p>See separate template for newspapers.</doc:p>
        </doc:note>
    </doc:doc>
    <xsl:template match="front-matter/serial[@type = 'death-certificate']/part" mode="bibliography.structure.serial.part">
        <xsl:copy-of select="volume" />
        <xsl:copy-of select="date[@rel = 'issue']" />        
        <xsl:copy-of select="issue" />
    </xsl:template>
    
    
    <doc:doc>
        <doc:desc>Add the serial volume and/or issue into the structure of a bibliographic reference.</doc:desc>
    </doc:doc>
    <xsl:template match="pages[ancestor::front-matter/parent::source]" mode="bibliography.structure.serial.pages">
        <xsl:copy-of select="self::*" />
    </xsl:template>
    
    
    <xsl:template match="*[name() = $contributor-roles]/@ref" mode="#all" />
   
    
</xsl:stylesheet>
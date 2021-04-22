<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsd="http://www.w3.org/2001/XMLSchema"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:oxy="http://www.oxygenxml.com/schematron/validation"
                version="2.0"
                xml:base="file:/home/sheila/Code/repositories/sapling/schemas/sapling/sapling.sch_xslt_cascade"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri">
      <xsl:value-of select="document-uri(/)"/>
   </xsl:variable>
   <!--PHASES-->
   <!--PROLOG-->
   <xsl:output xmlns:iso="http://purl.oclc.org/dsdl/schematron" method="xml"/>
   <!--XSD TYPES FOR XSLT2-->
   <!--KEYS AND FUNCTIONS-->
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:variable name="sameUri">
         <xsl:value-of select="saxon:system-id() = parent::node()/saxon:system-id()"
                       use-when="function-available('saxon:system-id')"/>
         <xsl:value-of select="oxy:system-id(.) = oxy:system-id(parent::node())"
                       use-when="not(function-available('saxon:system-id')) and function-available('oxy:system-id')"/>
         <xsl:value-of select="true()"
                       use-when="not(function-available('saxon:system-id')) and not(function-available('oxy:system-id'))"/>
      </xsl:variable>
      <xsl:if test="$sameUri = 'true'">
         <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      </xsl:if>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*:</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>[namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:if test="$sameUri = 'true'">
         <xsl:variable name="preceding"
                       select="count(preceding-sibling::*[local-name()=local-name(current())       and namespace-uri() = namespace-uri(current())])"/>
         <xsl:text>[</xsl:text>
         <xsl:value-of select="1+ $preceding"/>
         <xsl:text>]</xsl:text>
      </xsl:if>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="text()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>text()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::text())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="comment()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>comment()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::comment())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>processing-instruction()</xsl:text>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::processing-instruction())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M2"/>
      <xsl:apply-templates select="/" mode="M3"/>
      <xsl:apply-templates select="/" mode="M4"/>
      <xsl:apply-templates select="/" mode="M5"/>
      <xsl:apply-templates select="/" mode="M6"/>
      <xsl:apply-templates select="/" mode="M7"/>
      <xsl:apply-templates select="/" mode="M8"/>
      <xsl:apply-templates select="/" mode="M9"/>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <xsl:param name="today" select="current-date()"/>
   <xsl:param name="current-year" select="year-from-date($today)"/>
   <!--PATTERN Date-->
   <!--RULE -->
   <xsl:template match="date" priority="1000" mode="M2">
      <xsl:variable name="month-name"
                    select="     if (normalize-space(@month) != '')     then (      if (@month = 1)       then 'January'      else if (@month = 2)      then 'February'      else if (@month = 3)      then 'March'      else if (@month = 4)      then 'April'      else if (@month = 5)      then 'May'      else if (@month = 6)      then 'June'      else if (@month = 7)      then 'July'      else if (@month = 8)      then 'August'      else if (@month = 9)      then 'September'      else if (@month = 10)      then 'October'      else if (@month = 11)      then 'November'      else if (@month = 12)      then 'December'      else ''     )     else ''"/>
      <xsl:variable name="max-days"
                    select="     if ($month-name = 'February') then 29     else if ($month-name = ('April', 'June', 'September', 'November')) then 30     else 31"/>
      <!--REPORT -->
      <xsl:if test="self::*/@month[$month-name != ''][. &lt; 1 or . &gt; 12]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Invalid date. Month must be between 1 and 12.</xsl:text>
         </xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="self::*[@day = '']">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Invalid date. Day value must be a number.</xsl:text>
         </xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="self::*[@month]/@day[. != ''][. &gt; $max-days]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Invalid date. Too many days in the month. No more than </xsl:text>
            <xsl:text/>
            <xsl:value-of select="$max-days"/>
            <xsl:text/>
            <xsl:text> expected</xsl:text>
            <xsl:text/>
            <xsl:value-of select="if ($month-name != '') then concat(' in ', $month-name) else ()"/>
            <xsl:text/>
            <xsl:text>.</xsl:text>
         </xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="self::*[@day]/not(@month)">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Invalid date. A date with a day value must also have a month value.</xsl:text>
         </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="@*|node()" mode="M2"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M2"/>
   <xsl:template match="@*|node()" priority="-2" mode="M2">
      <xsl:apply-templates select="@*|node()" mode="M2"/>
   </xsl:template>
   <!--PATTERN ISBN-->
   <!--RULE -->
   <xsl:template match="isbn" priority="1000" mode="M3">
      <xsl:variable name="isbn-normalised" select="translate(., 'x- ', 'X')"/>
      <xsl:variable name="version"
                    select="     if (string-length($isbn-normalised) = 10)      then '10'      else if (string-length($isbn-normalised) = 13)     then '13'     else 'invalid'"/>
      <xsl:variable name="check-digit"
                    select="     if ($version = '13')     then xs:string(substring($isbn-normalised, 13, 1))     else ''"/>
      <xsl:variable name="check-mod"
                    select="      if ($version ='10')     then       (       (xs:integer(substring($isbn-normalised, 1, 1)) * 10) +       (xs:integer(substring($isbn-normalised, 2, 1)) * 9) +       (xs:integer(substring($isbn-normalised, 3, 1)) * 8) +       (xs:integer(substring($isbn-normalised, 4, 1)) * 7) +       (xs:integer(substring($isbn-normalised, 5, 1)) * 6) +       (xs:integer(substring($isbn-normalised, 6, 1)) * 5) +       (xs:integer(substring($isbn-normalised, 7, 1)) * 4) +       (xs:integer(substring($isbn-normalised, 8, 1)) * 3) +       (xs:integer(substring($isbn-normalised, 9, 1)) * 2) +       (        if (substring($isbn-normalised, 10, 1) = 'X')         then 10        else xs:integer(substring($isbn-normalised, 10, 1)       ) * 1)      ) mod 11     else if ($version = '13')      then       (       (xs:integer(substring($isbn-normalised, 1, 1)) * 1) +       (xs:integer(substring($isbn-normalised, 2, 1)) * 3) +       (xs:integer(substring($isbn-normalised, 3, 1)) * 1) +       (xs:integer(substring($isbn-normalised, 4, 1)) * 3) +       (xs:integer(substring($isbn-normalised, 5, 1)) * 1) +       (xs:integer(substring($isbn-normalised, 6, 1)) * 3) +       (xs:integer(substring($isbn-normalised, 7, 1)) * 1) +       (xs:integer(substring($isbn-normalised, 8, 1)) * 3) +       (xs:integer(substring($isbn-normalised, 9, 1)) * 1) +       (xs:integer(substring($isbn-normalised, 10, 1)) * 3) +       (xs:integer(substring($isbn-normalised, 11, 1)) * 1) +       (xs:integer(substring($isbn-normalised, 12, 1)) * 3)      ) mod 10     else ''"/>
      <xsl:variable name="check-value"
                    select="xs:string(      if ($version = '13')      then       if ($check-mod &gt; 0)        then 10 - $check-mod       else 0      else $check-mod     )"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::*[translate(., '0123456789X- ', '') = '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Invalid ISBN. Unexpected character(s): </xsl:text>
               <xsl:text/>
               <xsl:value-of select="translate(., '0123456789X- ', '')"/>
               <xsl:text/>
               <xsl:text> </xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::*[$version != '']"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Invalid ISBN. An ISBN must be either 10 or 13 characters long.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::*[($version = '10' and $check-value = '0') or ($check-value = $check-digit)]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Invalid ISBN. The check digit does not match the value of the check sum.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M3"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M3"/>
   <xsl:template match="@*|node()" priority="-2" mode="M3">
      <xsl:apply-templates select="@*|node()" mode="M3"/>
   </xsl:template>
   <!--PATTERN Event-->
   <!--RULE -->
   <xsl:template match="event[not(@*:status = 'alternative')]"
                 priority="1000"
                 mode="M4">
      <xsl:variable name="type" select="@type"/>
      <xsl:variable name="subjects" select="person"/>
      <!--REPORT -->
      <xsl:if test="preceding-sibling::event[@type = $type and $type != 'marriage'][person/@ref = $subjects/@ref]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Duplicate </xsl:text>
            <xsl:text/>
            <xsl:value-of select="$type"/>
            <xsl:text/>
            <xsl:text>.</xsl:text>
         </xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="self::event[not($type = ('birth', 'adoption'))]/parent">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Unexpected parent. The parent element may only be used in birth or adoption events.</xsl:text>
         </xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="self::event[$type = 'historical']/*[name() = ('person', 'parent')]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Unexpected </xsl:text>
            <xsl:text/>
            <xsl:value-of select="name(.)"/>
            <xsl:text/>
            <xsl:text>. References to people may only be used in the summary of a historical event.</xsl:text>
         </xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="self::event[not($type = 'historical')]/location[preceding-sibling::location]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Unexpected location. An event may only be associated with a single location, unless it is a historical event.</xsl:text>
         </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="@*|node()" mode="M4"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M4"/>
   <xsl:template match="@*|node()" priority="-2" mode="M4">
      <xsl:apply-templates select="@*|node()" mode="M4"/>
   </xsl:template>
   <!--PATTERN Person-->
   <xsl:variable name="century-ago" select="number($current-year) - 120"/>
   <!--RULE -->
   <xsl:template match="person" priority="1000" mode="M5">
      <xsl:variable name="birth-event"
                    select="if (ancestor::data/events/event[@type = 'birth'][not(@*:status = 'alternative')][person/@ref = current()/@id]) then ancestor::data/events/event[@type = 'birth'][not(@*:status = 'alternative')][person/@ref = current()/@id] else ancestor::data/events/event[@type = 'christening'][not(@*:status = 'alternative')][person/@ref = current()/@id]"/>
      <!--REPORT -->
      <xsl:if test="self::*[count($birth-event/date/@year) = 1]/@year[. != $birth-event/date/@year]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Invalid year. Birth event year recorded as </xsl:text>
            <xsl:text/>
            <xsl:value-of select="$birth-event/date/@year"/>
            <xsl:text/>
            <xsl:text>.</xsl:text>
         </xsl:message>
      </xsl:if>
      <!--REPORT -->
      <xsl:if test="self::*[@publish = 'false'][number(@year) &lt; $century-ago]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Unpublished Centenarian. Publish is set to false but this person is at least 100 years old.</xsl:text>
         </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="@*|node()" mode="M5"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M5"/>
   <xsl:template match="@*|node()" priority="-2" mode="M5">
      <xsl:apply-templates select="@*|node()" mode="M5"/>
   </xsl:template>
   <!--PATTERN Sources-->
   <xsl:variable name="events" select="/app/data/events/event"/>
   <xsl:variable name="people" select="/app/data/people/person"/>
   <xsl:variable name="locations" select="/app/data/locations/location"/>
   <xsl:variable name="organisations" select="/app/data/organisations/organisation"/>
   <!--RULE -->
   <xsl:template match="/app/data/sources/source" priority="1000" mode="M6">
      <xsl:variable name="source-id" select="self::source/@id"/>
      <xsl:variable name="total-references"
                    select="count(($events, $people, $locations, $organisations)/sources/source[@ref = $source-id])"/>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::source[$total-references &gt; 0]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Unused source. This source has NOT been referenced yet.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M6"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M6"/>
   <xsl:template match="@*|node()" priority="-2" mode="M6">
      <xsl:apply-templates select="@*|node()" mode="M6"/>
   </xsl:template>
   <!--PATTERN Source Extracts-->
   <!--RULE -->
   <xsl:template match="source/body-matter/extract" priority="1000" mode="M7">
      <xsl:variable name="highest-id"
                    select="parent::body-matter/extract[      @id/not(number(substring-after(., 'EXT')) &lt; parent::extract/preceding-sibling::extract/@id/number(substring-after(., 'EXT')))     ][      @id/not(number(substring-after(., 'EXT')) &lt; parent::extract/following-sibling::extract/@id/number(substring-after(., 'EXT')))     ][1]/@id"/>
      <xsl:variable name="next-id"
                    select="concat('EXT', number(substring-after($highest-id, 'EXT')) + 1)"/>
      <!--REPORT -->
      <xsl:if test="self::extract[@id = current()/preceding-sibling::extract/@id]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>Duplicate ID. </xsl:text>
            <xsl:text/>
            <xsl:value-of select="@id"/>
            <xsl:text/>
            <xsl:text> has already been assigned to an extract associated with this source. Change to </xsl:text>
            <xsl:text/>
            <xsl:value-of select="$next-id"/>
            <xsl:text/>
            <xsl:text> </xsl:text>
         </xsl:message>
      </xsl:if>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::extract[(pages or link) or ancestor::source/front-matter[descendant::pages or descendant::link]]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>Missing location. Either page numbers or a link to the extract must be provided.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M7"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M7"/>
   <xsl:template match="@*|node()" priority="-2" mode="M7">
      <xsl:apply-templates select="@*|node()" mode="M7"/>
   </xsl:template>
   <!--PATTERN Source Author Variants-->
   <!--RULE -->
   <xsl:template match="author/name" priority="1000" mode="M8">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::name[name[@family = 'yes']]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>New citation variant. Author has no family name.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--REPORT -->
      <xsl:if test="self::name[count(name[@family = 'yes']) &gt; 1]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>New citation variant. Author has more than one family name.</xsl:text>
         </xsl:message>
      </xsl:if>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::name[name[not(@family = 'yes')]]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>New citation variant. Author has no forename.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="@*|node()" mode="M8"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M8"/>
   <xsl:template match="@*|node()" priority="-2" mode="M8">
      <xsl:apply-templates select="@*|node()" mode="M8"/>
   </xsl:template>
   <!--PATTERN Source Title Variants-->
   <!--RULE -->
   <xsl:template match="data/sources/source" priority="1000" mode="M9">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="self::source[front-matter/title]"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text>New citation variant. Source has no title.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--REPORT -->
      <xsl:if test="self::source[count(front-matter/title) &gt; 1]">
         <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
            <xsl:text>New citation variant. Source has more than one title.</xsl:text>
         </xsl:message>
      </xsl:if>
      <xsl:apply-templates select="@*|node()" mode="M9"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M9"/>
   <xsl:template match="@*|node()" priority="-2" mode="M9">
      <xsl:apply-templates select="@*|node()" mode="M9"/>
   </xsl:template>
</xsl:stylesheet>

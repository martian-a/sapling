<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:functx="http://www.functx.com"
    xmlns:temp="http://ns.thecodeyard.co.uk/temp"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:template match="birth" mode="events">              
        <event type="birth">
            <xsl:if test="preceding-sibling::birth">
                <xsl:attribute name="temp:status">alternative</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="date" mode="#current" />
            <xsl:apply-templates select="ancestor::individual[1]/@id" mode="#current" />
            <xsl:apply-templates select="ancestor::file/family[@id = current()/ancestor::individual[1]/family-child/text()]/*[local-name() = ('husband', 'wife')]" mode="parent-ref">
                <xsl:with-param name="child-id" select="ancestor::individual[1]/@id" as="xs:string" tunnel="yes" />
            </xsl:apply-templates>
            <xsl:apply-templates select="place/place-name" mode="#current" />
            <sources>
                <xsl:apply-templates select="source-citation" mode="reference" />
            </sources>
        </event>
    </xsl:template>
    
    <xsl:template match="death" mode="events">              
        <event type="death">
            <xsl:if test="preceding-sibling::death">
                <xsl:attribute name="temp:status">alternative</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates select="date" mode="#current" />
            <xsl:apply-templates select="ancestor::individual[1]/@id" mode="#current" />                           
            <xsl:apply-templates select="place/place-name" mode="#current" />
            <sources>
                <xsl:apply-templates select="source-citation" mode="reference" />
            </sources>
        </event>
    </xsl:template>
    
    
    <xsl:template match="individual/@id" mode="events">
        <person ref="{.}" />
    </xsl:template>
    
    <xsl:template match="family/*" mode="parent-ref">
        <xsl:param name="child-id" as="xs:string" tunnel="yes" />
        <parent ref="{.}">
            <xsl:attribute name="type">
                <xsl:choose>
                    <xsl:when test="local-name() = 'husband'"><xsl:value-of select="parent::family/child[@ref = $child-id]/f-relationship" /></xsl:when>
                    <xsl:otherwise><xsl:value-of select="parent::family/child[@ref = $child-id]/m-relationship" /></xsl:otherwise>
                </xsl:choose>
            </xsl:attribute>
        </parent>
    </xsl:template>
    
    <xsl:template match="place-name" mode="events">
        <location><xsl:value-of select="." /></location>
    </xsl:template>
    
    <xsl:template match="date" mode="events">
        <xsl:variable name="month-names" select="('jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec')" as="xs:string*" />
        <xsl:variable name="date-raw-parts" select="tokenize(., ' ')[normalize-space() != '']" as="xs:string*" />                              
        <xsl:variable name="date" as="xs:date?">
            <xsl:try select="functx:date($date-raw-parts[position() = last()], index-of($month-names, lower-case(substring($date-raw-parts[2], 1, 3))), $date-raw-parts[1])">
                <xsl:catch select="()" />                                   
            </xsl:try>
        </xsl:variable>               
        <date>
            <xsl:choose>
                <xsl:when test="exists($date)">
                    <xsl:attribute name="day" select="day-from-date($date)" />
                    <xsl:attribute name="month" select="month-from-date($date)" />
                    <xsl:attribute name="year" select="year-from-date($date)" />
                </xsl:when>
                <xsl:when test="count($date-raw-parts) = 1">
                    <xsl:attribute name="year" select="$date-raw-parts" />
                </xsl:when>
                <xsl:when test="count($date-raw-parts) = 2 and count(index-of($month-names, lower-case(substring($date-raw-parts[1], 1, 3)))) > 0">
                    <xsl:attribute name="month" select="index-of($month-names, lower-case(substring($date-raw-parts[1], 1, 3)))" />
                    <xsl:attribute name="year" select="$date-raw-parts[last()]" />
                </xsl:when>
            </xsl:choose>
            <xsl:comment><xsl:value-of select="." /></xsl:comment>
        </date>
    </xsl:template>
    
    <xsl:template match="birth/source-citation" mode="reference">
        <xsl:variable name="data-points" as="xs:string*">
            <xsl:if test="normalize-space(ancestor::birth[1]/date) != ''"><xsl:text>Date.</xsl:text></xsl:if>
            <xsl:if test="normalize-space(ancestor::birth[1]/place/place-name) != ''"><xsl:text>Location.</xsl:text></xsl:if>
            <xsl:text>Child.</xsl:text>
            <xsl:if test="ancestor::file/family[@id = current()/ancestor::individual[1]/family-child/text()]/*[local-name() = ('husband', 'wife')][normalize-space() != '']"><xsl:text>Parents.</xsl:text></xsl:if>
        </xsl:variable>
        <xsl:value-of select="string-join($data-points, ' ')"/>
    </xsl:template>
    
    <xsl:template match="death/source-citation" mode="reference">
        <xsl:variable name="data-points" as="xs:string*">
            <xsl:if test="normalize-space(ancestor::death[1]/date) != ''"><xsl:text>Date.</xsl:text></xsl:if>
            <xsl:if test="normalize-space(ancestor::death[1]/place/place-name) != ''"><xsl:text>Location.</xsl:text></xsl:if>
        </xsl:variable>
        <xsl:value-of select="string-join($data-points, ' ')"/>
    </xsl:template>
    
    
    <xsl:function name="functx:date" as="xs:date">
        <xsl:param name="year" as="xs:anyAtomicType"/>
        <xsl:param name="month" as="xs:anyAtomicType"/>
        <xsl:param name="day" as="xs:anyAtomicType"/>
        
        <xsl:sequence select="
            xs:date(
            concat(
            functx:pad-integer-to-length(xs:integer($year),4),'-',
            functx:pad-integer-to-length(xs:integer($month),2),'-',
            functx:pad-integer-to-length(xs:integer($day),2)))
            "/>
        
    </xsl:function>
    
    <xsl:function name="functx:pad-integer-to-length" as="xs:string">
        <xsl:param name="integerToPad" as="xs:anyAtomicType?"/>
        <xsl:param name="length" as="xs:integer"/>
        
        <xsl:sequence select="
            if ($length &lt; string-length(string($integerToPad)))
            then error(xs:QName('functx:Integer_Longer_Than_Length'))
            else concat
            (functx:repeat-string(
            '0',$length - string-length(string($integerToPad))),
            string($integerToPad))
            "/>
        
    </xsl:function>
    
    <xsl:function name="functx:repeat-string" as="xs:string">
        <xsl:param name="stringToRepeat" as="xs:string?"/>
        <xsl:param name="count" as="xs:integer"/>
        
        <xsl:sequence select="
            string-join((for $i in 1 to $count return $stringToRepeat),
            '')
            "/>
        
    </xsl:function>
    
</xsl:stylesheet>
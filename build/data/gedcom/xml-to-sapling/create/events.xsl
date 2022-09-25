<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:functx="http://www.functx.com"
    xmlns:temp="http://ns.thecodeyard.co.uk/temp"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
	
	
    <xsl:output indent="yes" />
    
    <xsl:template match="/">        
    	<events>
    		<xsl:apply-templates select="file/individual/birth" mode="events" />
    		<xsl:apply-templates select="file/individual[not(birth)]/family-child" mode="events" />
    		<xsl:apply-templates select="file/individual/baptism" mode="events" />
    		<xsl:apply-templates select="file/family/marriage" mode="events" />
    		<xsl:apply-templates select="file/individual/death" mode="events" />
    		<xsl:apply-templates select="file/individual/burial" mode="events" />
    		<xsl:apply-templates select="file/individual/residence" mode="events" />
    	</events>  		        	
    </xsl:template>       
    

	<xsl:template match="birth | family-child" mode="events" priority="1">
        <event type="birth" id="EVE-{generate-id()}">
            <xsl:if test="preceding-sibling::birth">
                <xsl:attribute name="temp:status">alternative</xsl:attribute>
            </xsl:if>
            <xsl:next-match />
        </event>
	</xsl:template>
	
	<xsl:template match="birth" mode="events">       
		<xsl:variable name="subject" select="ancestor::individual[1]/@id" as="xs:string" />
		<xsl:apply-templates select="date" mode="#current" />
        <xsl:apply-templates select="ancestor::individual[1]/@id" mode="#current" />
        <xsl:apply-templates select="ancestor::file/family[@id = current()/ancestor::individual[1]/family-child/@ref]" mode="birth">
            <xsl:with-param name="child-id" select="$subject" as="xs:string" tunnel="yes" />
        </xsl:apply-templates>
        <xsl:apply-templates select="place/place-name" mode="#current" />
    	<xsl:apply-templates select="value" mode="notes" />
		<xsl:if test="source-citation">
	        <sources>
	            <xsl:apply-templates select="source-citation" mode="reference" />
	        </sources>
		</xsl:if>
    </xsl:template>
    
    <xsl:template match="family-child" mode="birth">
        <xsl:apply-templates select="ancestor::individual[1]/@id" mode="events" />
        <xsl:apply-templates select="ancestor::file/family[@id = current()/@ref]" mode="#current">
            <xsl:with-param name="child-id" select="ancestor::individual[1]/@id" as="xs:string" tunnel="true" />
        </xsl:apply-templates>
    </xsl:template>
    
    <xsl:template match="family" mode="birth">  
    	<xsl:param name="child-id" as="xs:string" tunnel="yes" />
    	<xsl:if test="child[@ref = $child-id][not(*[ends-with(local-name(), '-relationship')][. != 'biological'])]">
        	<xsl:apply-templates select="husband" mode="parent-ref" />
        </xsl:if>    
    	<xsl:if test="child[@ref = $child-id][not(*[ends-with(local-name(), '-relationship')][. != 'biological'])]">
    		<xsl:apply-templates select="wife" mode="parent-ref" />
    	</xsl:if>    	
    </xsl:template>
	
	<xsl:template match="baptism" mode="events" priority="10">
		<event type="christening" id="EVE-{generate-id()}">
			<xsl:if test="preceding-sibling::baptism">
				<xsl:attribute name="temp:status">alternative</xsl:attribute>
			</xsl:if>
			<xsl:next-match />
		</event>
	</xsl:template>
	
	<xsl:template match="family/marriage" mode="events">
		<event type="marriage" id="EVE-{generate-id()}">
			<xsl:apply-templates select="date" mode="#current" />
			<xsl:for-each select="ancestor::family[1]/(husband, wife)">
				<xsl:apply-templates select="/file/individual[@id = current()/@ref]/@id" mode="#current" />
			</xsl:for-each>                         
			<xsl:apply-templates select="place/place-name" mode="#current" />
			<xsl:apply-templates select="value" mode="note" />
			<sources>
				<xsl:apply-templates select="source-citation" mode="reference" />
			</sources>
		</event>
	</xsl:template>
	    
	<xsl:template match="residence" mode="events" priority="10"> 
		<xsl:variable name="event-type" select="local-name()" as="xs:string" />
		<event type="{$event-type}" id="EVE-{generate-id()}">
			<xsl:next-match />
		</event>
	</xsl:template>	    
	    
    <xsl:template match="death | burial" mode="events" priority="10"> 
    	<xsl:variable name="event-type" select="local-name()" as="xs:string" />
    	<event type="{$event-type}" id="EVE-{generate-id()}">
            <xsl:if test="preceding-sibling::*[local-name() = $event-type]">
                <xsl:attribute name="temp:status">alternative</xsl:attribute>
            </xsl:if>
            <xsl:next-match />
        </event>
    </xsl:template>
	
    <xsl:template match="death | baptism | burial | residence" mode="events">
    	<xsl:apply-templates select="date" mode="#current" />
    	<xsl:apply-templates select="ancestor::individual[1]/@id" mode="#current" />                           
    	<xsl:apply-templates select="place/place-name" mode="#current" />
    	<sources>
    		<xsl:apply-templates select="source-citation" mode="reference" />
    	</sources>
    </xsl:template>
    
    
    <xsl:template match="individual/@id" mode="events">
        <person ref="{.}" />
    </xsl:template>
    
    <xsl:template match="family/*" mode="parent-ref">
        <xsl:param name="child-id" as="xs:string" tunnel="yes" />
        <parent>
        	<xsl:copy-of select="@ref" />
        </parent>
    </xsl:template>
    
    <xsl:template match="place-name" mode="events">
        <location context="{string-join((tokenize(normalize-space(.), ',') ! normalize-space(.)), ', ')}" />
    </xsl:template>
    
    <xsl:template match="date" mode="events">
        <xsl:variable name="month-names" select="('jan', 'feb', 'mar', 'apr', 'may', 'jun', 'jul', 'aug', 'sep', 'oct', 'nov', 'dec')" as="xs:string*" />
        <xsl:variable name="date-string-raw-parts" select="tokenize(translate(lower-case(.), '.', ''), ' ')[normalize-space() != '']" as="xs:string*" />                              
    	<xsl:variable name="modifier" as="xs:string?">
    		<xsl:choose>
    			<xsl:when test="$date-string-raw-parts[1] = ('bef', 'before')">Before</xsl:when>
    			<xsl:when test="$date-string-raw-parts[1] = ('abt', 'about')">About</xsl:when>
    			<xsl:when test="$date-string-raw-parts[1] = ('aft', 'after')">After</xsl:when>
    		</xsl:choose>
    	</xsl:variable>
    	<xsl:variable name="date-raw-parts" select="if ($modifier) then $date-string-raw-parts[position() > 1] else $date-string-raw-parts" as="xs:string*" />
    	<xsl:variable name="date" as="xs:date?">
            <xsl:try select="functx:date($date-raw-parts[position() = last()], index-of($month-names, substring($date-raw-parts[count($date-raw-parts) - 1], 1, 3)), $date-raw-parts[count($date-raw-parts) - 2])">
                <xsl:catch select="()" />                                   
            </xsl:try>
        </xsl:variable>    

        <date>
			<xsl:if test="$modifier">
				<xsl:attribute name="modifier" select="$modifier" />
			</xsl:if>
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
            <xsl:if test="ancestor::file/family[@id = current()/ancestor::individual[1]/family-child/@ref]/*[local-name() = ('husband', 'wife')][normalize-space() != '']"><xsl:text>Parents.</xsl:text></xsl:if>
        </xsl:variable>
        <xsl:value-of select="string-join($data-points, ' ')"/>
    </xsl:template>
    
    <xsl:template match="source-citation[not(parent::birth)]" mode="reference">
        <xsl:variable name="data-points" as="xs:string*">
            <xsl:if test="normalize-space(ancestor::*[parent::individual][1]/date) != ''"><xsl:text>Date.</xsl:text></xsl:if>
        	<xsl:if test="normalize-space(ancestor::*[parent::individual][1]/place/place-name) != ''"><xsl:text>Location.</xsl:text></xsl:if>
        </xsl:variable>
        <xsl:value-of select="string-join($data-points, ' ')"/>
    </xsl:template>
	
	<xsl:template match="value" mode="note">
		<note>
			<p><xsl:value-of select="." /></p>
		</note>
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


	<xsl:include href="shared.xsl" />
    
</xsl:stylesheet>
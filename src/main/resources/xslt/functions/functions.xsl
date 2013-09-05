<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:kai="http://ns.kaikoda.com/xslt/functions"
    exclude-result-prefixes="xs kai"
    version="2.0">
	
	<xsl:function name="kai:getDate" as="xs:date?">
		<xsl:param name="date-element" as="element()?" />                  	        	        
		
		<xsl:if test="not(normalize-space($date-element/@year) = '') and not(normalize-space($date-element/@month) = '') and not(normalize-space($date-element/@day) = '')">
			<xsl:value-of select="concat($date-element/@year, '-', kai:pad($date-element/@month, '0', 2), '-', kai:pad($date-element/@day, '0', 2)) cast as xs:date?" />
		</xsl:if>			
	</xsl:function>
    
    <xsl:function name="kai:getLongMonthName" as="xs:string?">
    	<xsl:param name="date-element" as="element()?" />
    	
    	<xsl:variable name="month" select="normalize-space($date-element/@month)" as="xs:string?" />    	
        
    	<xsl:choose>
    		<xsl:when test="$month = '1'">January</xsl:when>
    		<xsl:when test="$month = '2'">February</xsl:when>
    		<xsl:when test="$month = '3'">March</xsl:when>
    		<xsl:when test="$month = '4'">April</xsl:when>
    		<xsl:when test="$month = '5'">May</xsl:when>
    		<xsl:when test="$month = '6'">June</xsl:when>
    		<xsl:when test="$month = '7'">July</xsl:when>
    		<xsl:when test="$month = '8'">August</xsl:when>
    		<xsl:when test="$month = '9'">September</xsl:when>
    		<xsl:when test="$month = '10'">October</xsl:when>
    		<xsl:when test="$month = '11'">November</xsl:when>
    		<xsl:when test="$month = '12'">December</xsl:when>
    	</xsl:choose>
    	
    </xsl:function>
    
    <xsl:function name="kai:getShortMonthName" as="xs:string?">
    	<xsl:param name="date-element" as="element()?" />
        
    	<xsl:value-of select="substring(kai:getLongMonthName($date-element), 1, 3)" />
        
    </xsl:function>
    
    <xsl:function name="kai:getEventId" as="xs:integer?">
        <xsl:param name="prefixedId" as="xs:string?" />
        
        <xsl:value-of select="substring-after($prefixedId, 'EVE')" />        
    </xsl:function>  
    
    
    <xsl:function name="kai:getPersonId" as="xs:integer?">
        <xsl:param name="prefixedId" as="xs:string?" />
        
        <xsl:value-of select="substring-after($prefixedId, 'PER')" />        
    </xsl:function>   
    
    <xsl:function name="kai:getEventTypeLabel" as="xs:string">
        <xsl:param name="type" as="xs:string" />
        
    	<xsl:value-of select="concat(upper-case(substring($type, 1, 1)), substring($type, 2, string-length($type) - 1))" />
    </xsl:function>
    
    
	<xsl:function name="kai:getDayname" as="xs:string?">
		<xsl:param name="date-element" as="element()?" />                  	        	        		   
		
		<xsl:variable name="date" select="kai:getDate($date-element)" as="xs:date?" />
		
		<xsl:if test="not($date = ())">
			<xsl:value-of select="format-date($date, '[FNn]', 'en', (), ())" />
		</xsl:if>
		
	</xsl:function>
	
	<xsl:function name="kai:getOrdinal" as="xs:string?">
		<xsl:param name="number" as="xs:string?" />
		
		<xsl:variable name="normalised-number" select="normalize-space($number)" as="xs:string?" />
		
		<xsl:choose>
			<xsl:when test="ends-with($normalised-number, '1')">st</xsl:when>
			<xsl:when test="ends-with($normalised-number, '2')">nd</xsl:when>
			<xsl:when test="ends-with($normalised-number, '3')">rd</xsl:when>
			<xsl:when test="ends-with($normalised-number, '4')">th</xsl:when>
			<xsl:when test="ends-with($normalised-number, '5')">th</xsl:when>
			<xsl:when test="ends-with($normalised-number, '6')">th</xsl:when>
			<xsl:when test="ends-with($normalised-number, '7')">th</xsl:when>
			<xsl:when test="ends-with($normalised-number, '8')">th</xsl:when>
			<xsl:when test="ends-with($normalised-number, '9')">th</xsl:when>
			<xsl:when test="ends-with($normalised-number, '0')">th</xsl:when>			
		</xsl:choose>
		
	</xsl:function>
	
	<xsl:function name="kai:pad" as="xs:string?">
		<xsl:param name="original-value" as="xs:string?" />
		<xsl:param name="padding" as="xs:string?" />
		<xsl:param name="length" as="xs:integer?" />
		
		<xsl:choose>
			<xsl:when test="$length &gt; string-length($original-value)">
				<xsl:value-of select="kai:pad(concat($padding, $original-value), $padding, $length)" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$original-value" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
    
</xsl:stylesheet>
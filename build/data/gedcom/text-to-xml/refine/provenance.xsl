<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:functx="http://www.functx.com"
    xmlns:ged="http://gedcomx.org/v5-5-1/"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
	
	<xsl:import href="../../../../utils/identity.xsl" />
       
	<xsl:variable name="months-of-year" as="element()*">
		<month number="1" abbreviation="Jan">January</month>
		<month number="2" abbreviation="Feb">February</month>
		<month number="3" abbreviation="Mar">March</month>
		<month number="4" abbreviation="Apr">April</month>
		<month number="5" abbreviation="May">May</month>
		<month number="6" abbreviation="Jun">Jun</month>
		<month number="7" abbreviation="Jul">Jul</month>
		<month number="8" abbreviation="Aug">August</month>
		<month number="9" abbreviation="Sep">September</month>
		<month number="10" abbreviation="Oct">October</month>
		<month number="11" abbreviation="Nov">November</month>
		<month number="12" abbreviation="Dec">December</month>
	</xsl:variable>       
       
    <xsl:template match="prov:document">
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates />
        	<xsl:apply-templates select="/file/head/transmission-date" mode="prov" />
        	<xsl:apply-templates select="/file/head/source-description" mode="prov"/>
        </xsl:copy>
    </xsl:template>
         
	<xsl:template match="/file/head/transmission-date" mode="prov">
		<xsl:variable name="agent-id" select="concat('REPLACE-', generate-id(ancestor::head[1]/source-description/name-of-business/value))" as="xs:string" />
		<xsl:variable name="activity-id" select="concat('REPLACE-', generate-id(self::transmission-date))" as="xs:string" />
		<prov:wasGeneratedBy>
			<prov:entity prov:ref="{$agent-id}" />
			<prov:activity prov:ref="{$activity-id}" />
		</prov:wasGeneratedBy>
		<prov:entity prov:id="{$agent-id}">
			<foaf:name><xsl:value-of select="ancestor::head[1]/source-description/name-of-business/value" /></foaf:name> 
		</prov:entity>
		<prov:activity prov:id="{$activity-id}">
			<xsl:variable name="date-parts" select="tokenize(value)" as="xs:string*" />
			<prov:startTime><xsl:value-of select="dateTime(functx:date($date-parts[3], $months-of-year[@abbreviation = $date-parts[2]]/@number, $date-parts[1]), time-value/xs:time(text()))" /></prov:startTime>
		</prov:activity>
	</xsl:template>    
    
	<xsl:template match="/file/head/source-description" mode="prov">
		<xsl:variable name="tree-id" select="tree/automated-record-id/text()" as="xs:string"/>
    	<prov:wasDerivedFrom>
    		<prov:entity prov:ref="{$tree-id}" />
    	</prov:wasDerivedFrom>
		<prov:entity prov:id="{$tree-id}">
			<prov:location>https://<xsl:value-of select="name-of-business/web-link" />/family-tree/tree/<xsl:value-of select="$tree-id" />/</prov:location>
		</prov:entity>
    </xsl:template>	
	

	
	<xsl:function name="functx:repeat-string" as="xs:string"
		xmlns:functx="http://www.functx.com">
		<xsl:param name="stringToRepeat" as="xs:string?"/>
		<xsl:param name="count" as="xs:integer"/>
		
		<xsl:sequence select="
			string-join((for $i in 1 to $count return $stringToRepeat),
			'')
			"/>
		
	</xsl:function>
	
	<xsl:function name="functx:pad-integer-to-length" as="xs:string"
		xmlns:functx="http://www.functx.com">
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
	
	<xsl:function name="functx:date" as="xs:date"
		xmlns:functx="http://www.functx.com">
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
    
</xsl:stylesheet>
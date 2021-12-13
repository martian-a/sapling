<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">        
    	<xsl:apply-templates />          		        	
    </xsl:template>       
	
	<xsl:template match="people/person">
		<xsl:variable name="birth-year" as="xs:integer?" select="(
				/data/events/event[@type = 'birth'][person/@ref = current()/@id][1]/date/@year,
				/data/events/event[@type = 'christening'][person/@ref = current()/@id][1]/date/@year,
				(/data/events/event[@type = 'marriage'][person/@ref = current()/@id][1]/date/@year/number(.) - 14),
				(/data/events/event[@type = 'birth'][parent/@ref = current()/@id][1]/date/@year/number(.) - 14),
				(/data/events/event[@type = 'christening'][parent/@ref = current()/@id][1]/date/@year/number(.) - 14)
			)[1] ! xs:integer(.)" />
				
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:if test="$birth-year">
				<xsl:attribute name="year" select="$birth-year" />
			</xsl:if>	
			<xsl:apply-templates />			
		</xsl:copy>
	</xsl:template>
    
    <xsl:include href="../../../../utils/identity.xsl" />
    
</xsl:stylesheet>
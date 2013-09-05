<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:kai="http://ns.kaikoda.com/xslt/functions"
    exclude-result-prefixes="xs kai"
    version="2.0">
    
    <xsl:variable name="event-id" select="/sapling/event/@id" />
    <xsl:variable name="primary-doc" select="/sapling" /> 
              
    <xsl:template match="date/@month" mode="event-month-long">
        <xsl:value-of select="kai:getLongMonthName(current()/parent::date)" />
    </xsl:template>	
  
    
</xsl:stylesheet>
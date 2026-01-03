<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">             
	
	<xsl:import href="../../../../utils/identity.xsl" />
	
	<xsl:output indent="yes" />    
    
    <xsl:variable name="header" select="/file/header" as="element()" />
	
	<xsl:template match="header" />
	
	<xsl:template match="record">
		<xsl:copy>			
		
			<xsl:for-each select="element">
				<xsl:variable name="header-label" select="$header/element[position() = count(current()/preceding-sibling::element)+1]/translate(., ' ', '-')" as="xs:string?" />
				<xsl:if test="$header-label != '#'">
					<xsl:element name="{$header-label}">
						<xsl:apply-templates />
					</xsl:element>
				</xsl:if>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="element/text()">
		<xsl:variable name="normalised-value" select="normalize-space(.)" as="xs:string?" />
		
		<xsl:choose>
			<xsl:when test="$normalised-value = ('', '#N/A')" />
			<xsl:otherwise><xsl:value-of select="$normalised-value" /></xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>
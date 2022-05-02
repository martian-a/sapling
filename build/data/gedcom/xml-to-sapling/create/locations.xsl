<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" />
    
    
	<xsl:template match="/">        		
		<locations xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
			<xsl:for-each-group select="descendant::place" group-by="normalize-space(tokenize(string-join(tokenize(normalize-space(place-name), ','), ', '), ',')[last()])">
				<xsl:call-template name="place">
					<xsl:with-param name="current-grouping-key" select="current-grouping-key()" as="xs:string" />
					<xsl:with-param name="current-group" select="current-group()" as="element()*" />
				</xsl:call-template>
			</xsl:for-each-group>
		</locations>
	</xsl:template>
	
	
	<xsl:template name="place">
		<xsl:param name="current-grouping-key" as="xs:string" />
		<xsl:param name="current-group" as="element()*" />
		<xsl:param name="context" as="xs:string?" />
		<xsl:param name="within" as="xs:string?" />
				
		<xsl:variable name="context" select="string-join(($current-grouping-key, $context), ', ')" as="xs:string" />		
		<location id="{$context}" context="{$context}">
			<name><xsl:value-of select="$current-grouping-key" /></name>
			<xsl:if test="$within">
				<within ref="{$within}" />
			</xsl:if>			
		</location>						
		<xsl:for-each-group select="$current-group" group-by="
			normalize-space(
				(
					tokenize(
						substring(place-name, 1, string-length(place-name) - string-length($context)),
						','
					) ! normalize-space(.)
				)[. != ''][last()]
			)">
			<xsl:if test="normalize-space(current-grouping-key()) != ''">
				<xsl:call-template name="place">
					<xsl:with-param name="current-grouping-key" select="current-grouping-key()" as="xs:string" />
					<xsl:with-param name="current-group" select="current-group()" as="element()*" />
					<xsl:with-param name="context" select="$context" />
					<xsl:with-param name="within" select="$context" />
				</xsl:call-template>
			</xsl:if>
		</xsl:for-each-group>
		
	</xsl:template>
	
</xsl:stylesheet>
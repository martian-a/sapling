<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">        
        <locations xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#">
        	<xsl:for-each-group select="descendant::place" group-by="normalize-space(place-name)">
        		<xsl:variable name="group-id" select="concat('LOC-', generate-id())" as="xs:string" />
        		<xsl:for-each select="tokenize(current-grouping-key(), ',')">
        			<location id="{$group-id}_{position()}" context="{current-grouping-key()}">
        				<name><xsl:value-of select="normalize-space(.)" /></name>
        				<xsl:if test="position() != last()">
        					<within ref="{$group-id}_{position() + 1}" />
        				</xsl:if>
        			</location>
        		</xsl:for-each>
        	</xsl:for-each-group>
        </locations>        		        	
    </xsl:template>       
    
</xsl:stylesheet>
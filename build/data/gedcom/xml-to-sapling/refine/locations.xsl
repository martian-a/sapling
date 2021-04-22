<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">        
    	<xsl:apply-templates />          		        	
    </xsl:template>       
	
	<xsl:template match="event/location[@context]">
		<xsl:variable name="candidates" as="element()*">
			<xsl:sequence select="/*/locations/location[@context = current()/normalize-space(@context)]" />		
		</xsl:variable>
		<xsl:copy>
			<xsl:for-each select="$candidates">
				<xsl:sort select="@id" order="ascending" />
				<xsl:if test="position() = 1">
					<xsl:attribute name="ref" select="@id" />
				</xsl:if>
			</xsl:for-each>
			<xsl:comment><xsl:value-of select="@context" /></xsl:comment>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="locations">
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			<xsl:apply-templates select="location">
				<xsl:sort select="name" order="ascending" data-type="text" />
				<xsl:sort select="within" order="ascending" data-type="text" />
				<xsl:sort select="@id" order="ascending" data-type="text" />
			</xsl:apply-templates>
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="locations/location/@context" />
    
    <xsl:include href="../../../../utils/identity.xsl" />
    
</xsl:stylesheet>
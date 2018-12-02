<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:include href="../../utils/identity.xsl" />
    
    <xsl:output encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />
        
    
    <xsl:template match="/">
        <xsl:result-document>
            <xsl:apply-templates />
        </xsl:result-document>
    </xsl:template>    
	
		
	<xsl:template match="/app/data/sources">
		
		<xsl:copy>
			<xsl:apply-templates select="@*" />
			
			<xsl:for-each-group select="source" group-by="@id">
				<xsl:apply-templates select="current-group()[1]" mode="join-source-extracts">
					<xsl:with-param name="current-group" select="current-group()" as="element()*" tunnel="yes" />
				</xsl:apply-templates>
			</xsl:for-each-group>
			
		</xsl:copy>
		
	</xsl:template>
	
	
	<xsl:template match="/app/data/sources/source/body-matter/*" mode="join-source-extracts">
		<xsl:param name="current-group" as="element()*" tunnel="yes" />
		
		<xsl:if test="position() = 1">
			<xsl:apply-templates select="$current-group/body-matter/*" />
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template match="element()" mode="join-source-extracts">
		<xsl:copy><xsl:apply-templates select="attribute(), node()" mode="#current" /></xsl:copy>
	</xsl:template>
	
	<xsl:template match="processing-instruction() | comment() | attribute() | text()" mode="join-source-extracts">
		<xsl:copy><xsl:apply-templates select="node()" mode="#current" /></xsl:copy>
	</xsl:template>
    
</xsl:stylesheet>
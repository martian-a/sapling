<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:bgt="http://ns.bluegumtree.com/saxon/functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">        
    	<people><xsl:apply-templates select="file/individual" mode="people" /></people>     		        	
    </xsl:template>       
    
	<xsl:template match="individual" mode="people">
		<xsl:variable name="personal-names" select="name[normalize-space(personal-name) != '']" as="element()*" />       
		<person id="{@id}">
			<xsl:apply-templates select="$personal-names[1]/personal-name" />
			<xsl:apply-templates select="$personal-names[position() > 1], alias" />
			<sources>
				<xsl:apply-templates select="name/source-citation" mode="reference" />
				<xsl:apply-templates select="sex/source-citation" mode="reference" />
			</sources>
		</person>
	</xsl:template>
	
	<xsl:template match="personal-name | alias">
		<persona id="PSA-{generate-id()}">            
			<name>
				<xsl:for-each select="tokenize(if (*) then value/text() else text(), ' ')">
					<xsl:element name="name">
						<xsl:choose>
							<xsl:when test="starts-with(., '/') and ends-with(., '/')">
								<xsl:attribute name="family">yes</xsl:attribute>
								<xsl:value-of select="translate(., '/', '')"/>
							</xsl:when>
							<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
						</xsl:choose>
					</xsl:element>
				</xsl:for-each>
			</name>
			<xsl:apply-templates select="ancestor::individual[1]/sex/value" />
		</persona>
	</xsl:template>       
	
	<xsl:template match="individual/sex/value">
		<gender><xsl:choose>
			<xsl:when test=". = 'F'">Female</xsl:when>
			<xsl:when test=". = 'M'">Male</xsl:when>
			<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
		</xsl:choose></gender>
	</xsl:template>
	
	<xsl:template match="individual/name/source-citation" mode="reference">
		<xsl:text>Name.</xsl:text>
	</xsl:template>
	
	<xsl:template match="individual/sex/source-citation" mode="reference">
		<xsl:text>Gender.</xsl:text>
	</xsl:template>
	
	
	
	<xsl:include href="shared.xsl" />
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:c="http://www.w3.org/ns/xproc-step"    
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="#all">
    
    <xsl:import href="../identity.xsl" />
    
    <xsl:output indent="yes" />
	
	<xsl:template match="/*">
		<xsl:copy>
			<xsl:copy-of select="//namespace::*" />
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>
	</xsl:template>
	    
	<xsl:template match="output-file-locations[ancestor::output-file-locations]">
		<xsl:apply-templates />
	</xsl:template>    
	    
	<xsl:template match="c:result">
		<xsl:variable name="filename-parts" select="tokenize(tokenize(text(), '/')[last()], '\.')" as="xs:string*" />		
		<xsl:variable name="schema" select="$filename-parts[count($filename-parts)-1]" as="xs:string" />
		<xsl:variable name="sub-dataset" as="xs:string?">
			<xsl:if test="not($filename-parts[3] = $filename-parts[count($filename-parts)-2])">
				<xsl:value-of select="$filename-parts[3]" />
			</xsl:if>
		</xsl:variable>
		<xsl:variable name="network-name" as="xs:string?">
			<xsl:if test="$schema = 'network'">									
				<xsl:value-of select="$filename-parts[count($filename-parts)-2]" />				
			</xsl:if>							
		</xsl:variable>
		
		<xsl:copy>
			<xsl:attribute name="dataset" select="string-join(($filename-parts[1], $filename-parts[2]), '.')" />
			<xsl:attribute name="schema" select="$schema" />
			<xsl:if test="not(normalize-space($sub-dataset) = '')">
				<xsl:attribute name="sub-dataset" select="$sub-dataset" />	
			</xsl:if>	
			<xsl:if test="$schema = 'network'">
				<xsl:attribute name="network-name" select="$network-name" />	
			</xsl:if>	
			<xsl:apply-templates select="@*, node()" />
		</xsl:copy>	
	</xsl:template>

</xsl:stylesheet>
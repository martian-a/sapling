<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">        
        <sources>
        	<xsl:apply-templates select="//source-description[@id]" />        	
        </sources>        		        	
    </xsl:template>       
	
	<xsl:template match="source-description">        
		<serial>
			<xsl:copy-of select="@id" />
			<xsl:apply-templates select="title, author, repository" />			
		</serial>        		        	
	</xsl:template>  
	
	<xsl:template match="source-description/title">
		<xsl:copy-of select="self::*" copy-namespaces="false" />
	</xsl:template>
		
	<xsl:template match="source-description/author[not(normalize-space(lower-case(.)) = 'ancestry.com')]">
		<author>
			<organisation>
				<name><xsl:value-of select="." /></name>
			</organisation>
		</author>
	</xsl:template>
	
	<xsl:template match="source-description/repository">
		<xsl:apply-templates select="/file/repository[@id = current()/@ref]" />
	</xsl:template>
	
	<xsl:template match="file/repository[@id]/name | source-description/author[normalize-space(lower-case(.)) = 'ancestry.com']">
		<xsl:choose>
			<xsl:when test="self::author[normalize-space(lower-case(.)) = /file/repository[@id]/name/normalize-space(lower-case(.))]">
				<!-- Suppress duplicate value -->
			</xsl:when>
			<xsl:otherwise>
				<publisher><xsl:value-of select="." /></publisher>		
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>
	
	<xsl:template match="file/repository[@id]/address">
		<location><xsl:value-of select="." /></location>
	</xsl:template>
	
	<xsl:template match="file/repository[@id]/note">
		<link href="{.}" />
	</xsl:template>   
    
</xsl:stylesheet>
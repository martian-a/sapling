<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:import href="../../../../utils/identity.xsl" />
    
    <xsl:param name="anchor-person-id" required="yes" />
    
    <xsl:output encoding="UTF-8" indent="yes" />
    <xsl:strip-space elements="*" />
    
    
    <xsl:template match="/">
        <xsl:result-document>
            <xsl:apply-templates />
        </xsl:result-document>
    </xsl:template>
    
    
    <xsl:template match="/data[people]">        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
        	<xsl:apply-templates select="*[not(local-name() = ('people', 'events', 'locations', 'sources', 'serials'))]" />
            <include>
                <xsl:apply-templates select="people" mode="include" />                    
            </include>
            <exclude>
                <xsl:apply-templates select="people" mode="to-temp" />                                   
            	<xsl:apply-templates select="*[local-name() = ('events', 'locations', 'sources', 'serials')]" />
            </exclude>
        </xsl:copy>
               
   </xsl:template>
    
    
    <xsl:template match="people" mode="include">        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="person[@id = $anchor-person-id]" />
        </xsl:copy>        
    </xsl:template>
    
    
    <xsl:template match="people" mode="to-temp">
        <xsl:param name="largest-cluster" as="element()*" />
        
        <xsl:copy>
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates select="person[not(@id = $anchor-person-id)]" />
        </xsl:copy>
       
    </xsl:template>
   
</xsl:stylesheet>
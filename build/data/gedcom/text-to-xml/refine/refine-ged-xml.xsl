<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output indent="yes" />
    
    <xsl:variable name="dictionaries" as="document-node()">
        <xsl:document>
            <dictionaries>
                <xsl:copy-of select="document('../../dictionaries/gedcom_5-5-1.xml')" />
                <xsl:copy-of select="document('../../dictionaries/ancestry_2021-7.xml')" />
            </dictionaries>
        </xsl:document>
    </xsl:variable>    
    
    <xsl:variable name="dictionary-entries" as="element()+" select="$dictionaries/*/*/entry" />

    <xsl:include href="head.xsl" />
    <xsl:include href="individual.xsl" />  
    <xsl:include href="family.xsl" />  
    <xsl:include href="source.xsl" />
    <xsl:include href="repeated-sub-structures.xsl" />
    <xsl:include href="place.xsl" /> 


    <xsl:template match="/">
        <xsl:document>
            <xsl:processing-instruction name="xml-model">href="http://ns.thecodeyard.co.uk/schema/sapling/gedcom/unexpected.sch?v=1.0.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>            
            <xsl:apply-templates />
        </xsl:document>
    </xsl:template>    
    
        
    <xsl:template match="*" mode="#all" priority="1">
        <xsl:next-match>
            <xsl:with-param name="expanded" select="$dictionary-entries[@abbreviation = current()/local-name()]/@expanded" as="xs:string?" />
        </xsl:next-match>        
    </xsl:template>
        
    <xsl:template match="* | comment() | processing-instruction()" mode="#all">
        <xsl:param name="expanded" as="xs:string?" />
        <xsl:element name="{if ($expanded) then $expanded else name()}">
            <xsl:apply-templates select="@*" />
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template> 
	
	<xsl:template match="attribute()" mode="#all">			
		<xsl:attribute name="{name()}"><xsl:choose>
			<xsl:when test="starts-with(., '@') and ends-with(., '@')"><xsl:value-of select="substring(., 2, string-length(.) - 2)" /></xsl:when>
			<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
		</xsl:choose></xsl:attribute>
	</xsl:template>
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="3.0">
    
	<xsl:param name="generated-by-user" select="''" />
	<xsl:param name="generated-by-pipeline" select="''" />
	<xsl:param name="transformation-start-time" select="current-dateTime()" />
    
	<xsl:variable name="source-uri" select="document-uri(/)" as="xs:string" />
    
    <xsl:import href="../default.xsl" />
	<xsl:import href="../../../provenance/prov-xml.xsl" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">
    	<xsl:document>
    		<xsl:processing-instruction name="xml-model">href="http://ns.thecodeyard.co.uk/schema/sapling-data.rnc?v=1.0.0" type="application/relax-ng-compact-syntax"</xsl:processing-instruction>    		
    		<xsl:processing-instruction name="xml-model">href="http://ns.thecodeyard.co.uk/schema/sapling.sch?v=3.0.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>            
    		<data name="{/*/@name}">    							    			
    			<xsl:apply-templates select="self::document-node()" mode="provenance-xml">
    				<xsl:with-param name="generated-by-user" select="$generated-by-user" as="xs:string?" />
    				<xsl:with-param name="generated-by-pipeline" select="$generated-by-pipeline" as="xs:string?" />
    				<xsl:with-param name="transformation-start-time" select="$transformation-start-time" as="xs:dateTime" />
    			</xsl:apply-templates>		               		       
    		</data>
    	</xsl:document>    	
        
    </xsl:template>       
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="3.0">
    
	<xsl:param name="generated-by-user" select="''" />
	<xsl:param name="generated-by-pipeline" select="''" />
	<xsl:param name="transformation-start-time" select="current-dateTime()" />
    
	<xsl:variable name="source-uri" select="document-uri(/)" as="xs:string" />
    
    <xsl:import href="../default.xsl" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">
    	<xsl:document>
    		<xsl:processing-instruction name="xml-model">href="http://ns.thecodeyard.co.uk/schema/sapling-data.rnc?v=1.0.0" type="application/relax-ng-compact-syntax"</xsl:processing-instruction>    		
    		<xsl:processing-instruction name="xml-model">href="http://ns.thecodeyard.co.uk/schema/sapling.sch?v=3.0.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>            
    		<data>
    			<xsl:copy-of select="/*/@*" />
    			<xsl:copy-of select="/*/*[namespace-uri() != '']" />
    		</data>
    	</xsl:document>    	
        
    </xsl:template>       
    
</xsl:stylesheet>
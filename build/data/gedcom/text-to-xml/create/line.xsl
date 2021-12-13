<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="2.0">                   

	<xsl:import href="../../../../utils/identity.xsl" />

    <xsl:output indent="yes" />    
    
    <xsl:template match="/file/content">
    		
    	<xsl:for-each select="tokenize(., '&#xA;|&#xD;')">
    		<line><xsl:value-of select="." /></line>
    	</xsl:for-each>
            
    </xsl:template>
    
</xsl:stylesheet>
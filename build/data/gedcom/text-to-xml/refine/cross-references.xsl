<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:import href="../../../../utils/identity.xsl" />
    
    <xsl:template match="*[text()[starts-with(., '@') and ends-with(., '@')]]">
    	<xsl:copy copy-namespaces="no">
    		<xsl:apply-templates select="text()" mode="create-xref" />
    		<xsl:apply-templates select="@*, node()[not(self::text()[starts-with(., '@') and ends-with(., '@')])]" />    		    	
    	</xsl:copy>
    </xsl:template>
             
	<xsl:template match="*[value[starts-with(., '@') and ends-with(., '@')]]">
		<xsl:copy copy-namespaces="no">
			<xsl:apply-templates select="value[starts-with(., '@') and ends-with(., '@')]/text()" mode="create-xref" />
			<xsl:apply-templates select="@*, node()[not(self::value[starts-with(., '@') and ends-with(., '@')])]" />    		    	
		</xsl:copy>
	</xsl:template>     
	
	<xsl:template match="text()[starts-with(., '@') and ends-with(., '@')]" mode="create-xref">
			<xsl:attribute name="ref" select="substring(., 2, string-length(.) - 2)" />	    			
	</xsl:template>	
    
</xsl:stylesheet>
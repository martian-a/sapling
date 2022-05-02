<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0"
    exclude-result-prefixes="xs">
    
    <xsl:import href="../../../../../cenizaro/tools/identity.xsl" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/rdf:RDF/*[not(@rdf:about = current()/preceding-sibling::*/@rdf:about)]">
        <xsl:variable name="resource-id" select="@rdf:about" as="xs:string" />
        
        <xsl:copy>
            <xsl:apply-templates select="@*, node()" />
            <xsl:apply-templates select="following-sibling::*[@rdf:about = $resource-id]/node()" />
        </xsl:copy>
        
    </xsl:template>      
    
    
    <xsl:template match="/rdf:RDF/*[@rdf:about = current()/preceding-sibling::*/@rdf:about]" />
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bio="http://purl.org/vocab/bio/0.1/"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:digest="http://nwalsh.com/xslt/ext/com.nwalsh.xslt.Digest"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
    xmlns:functx="http://www.functx.com"
    xmlns:gn="http://www.geonames.org/ontology#" 
    xmlns:greg="http://www.w3.org/ns/time/gregorian#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:rel="http://purl.org/vocab/relationship/"
    xmlns:sap="http://ns.thecodeyard.co.uk/data/sapling/resource/#"
    xmlns:time="http://www.w3.org/2006/time#"    
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs fn functx digest"
    version="3.0">    
    
	<xsl:param name="resource-base-uri" select="concat('http://ns.thecodeyard.co.uk/data/sapling/', /*/prov:document/@xml:id)" />
    
	<xsl:variable name="statement-delimiter" select="codepoints-to-string((59, 10, 9))"/>
    
    <xsl:output indent="yes" encoding="UTF-8" method="text" media-type="text/plain" />
    
    <xsl:template match="/">
    	<xsl:text>{</xsl:text><xsl:value-of select="codepoints-to-string((10, 9))" />
    	<xsl:text>&quot;nodes&quot;: [</xsl:text><xsl:value-of select="codepoints-to-string((10, 9, 9))" />        		 
        <xsl:apply-templates select="network/nodes/node[@id]" />
    	<xsl:text>],</xsl:text><xsl:value-of select="codepoints-to-string((10, 9))" />
    	<xsl:text>&quot;links&quot;: [</xsl:text><xsl:value-of select="codepoints-to-string((10, 9, 9))" />        		 
    	<xsl:apply-templates select="network/edges/edge[@id]" />
    	<xsl:text>]</xsl:text><xsl:value-of select="codepoints-to-string((10))" />
    	<xsl:value-of select="codepoints-to-string((10))" /><xsl:text>}</xsl:text>                  
    </xsl:template>       
    
    <!-- Nodes -->
    <xsl:template match="nodes/node">
    	<xsl:text>{</xsl:text><xsl:value-of select="codepoints-to-string((10, 9, 9, 9))" />
    	<xsl:text>&quot;id&quot;: &quot;</xsl:text><xsl:value-of select="@id" /><xsl:text>&quot;,</xsl:text><xsl:value-of select="codepoints-to-string((10, 9, 9, 9))" />
    	<xsl:text>&quot;name&quot;: &quot;</xsl:text><xsl:value-of select="." /><xsl:text>&quot;</xsl:text><xsl:value-of select="codepoints-to-string((10, 9, 9))" />
    	<xsl:text>}</xsl:text><xsl:if test="position() != last()">,</xsl:if><xsl:value-of select="codepoints-to-string((10, 9, 9))" />
    </xsl:template>	

	<!-- Edges -->
	<xsl:template match="edges/edge">
		<xsl:text>{</xsl:text><xsl:value-of select="codepoints-to-string((10, 9, 9, 9))" />
		<xsl:text>&quot;source&quot;: &quot;</xsl:text><xsl:value-of select="node[1]/@ref" /><xsl:text>&quot;,</xsl:text><xsl:value-of select="codepoints-to-string((10, 9, 9, 9))" />
		<xsl:text>&quot;target&quot;: &quot;</xsl:text><xsl:value-of select="node[2]/@ref" /><xsl:text>&quot;</xsl:text><xsl:value-of select="codepoints-to-string((10, 9, 9))" />
		<xsl:text>}</xsl:text><xsl:if test="position() != last()">,</xsl:if><xsl:value-of select="codepoints-to-string((10, 9, 9))" />
	</xsl:template>


</xsl:stylesheet>
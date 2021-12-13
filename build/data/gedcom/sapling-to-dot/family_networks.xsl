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
    
	<xsl:variable name="statement-delimiter" select="codepoints-to-string((59, 10))"/>
    
	<xsl:import href="../../provenance/prov-xml2rdf.xsl"/>
    
    <xsl:output indent="yes" encoding="UTF-8" method="text" />
    
    <xsl:template match="/">
        	<xsl:text>digraph </xsl:text><xsl:value-of select="data/void:dataset/@void:name" /><xsl:text> {
        		
        	</xsl:text>
        	<xsl:apply-templates select="data/people/person[@id]" />
    		<xsl:apply-templates select="data/events" mode="births" />
    		<xsl:apply-templates select="data/locations" />
    	
        	<xsl:text>}</xsl:text>            
    </xsl:template>       
    
    <!-- Nodes -->
    <xsl:template match="data/people/person">
    	<xsl:value-of select="@id" /><xsl:text> [</xsl:text><xsl:text>label = "</xsl:text><xsl:value-of select="persona[1]/name/string-join(*, ' ')" /><xsl:text>"]</xsl:text><xsl:value-of select="$statement-delimiter" />
    </xsl:template>	


	<xsl:template match="data/events" mode="births">
		<xsl:for-each-group select="event[@id][@type = 'birth']" group-by="string-join(('partners', parent/@ref), '_')">
			<xsl:value-of select="current-grouping-key()" /><xsl:text> [</xsl:text><xsl:text>label = "partnership" shape=diamond style=filled fillcolor=deeppink3 fontcolor=white]</xsl:text><xsl:value-of select="$statement-delimiter" />
			<xsl:for-each select="distinct-values(current-group()/parent/@ref)">
				<xsl:value-of select="." /><xsl:text> -> </xsl:text><xsl:value-of select="current-grouping-key()" /><xsl:value-of select="$statement-delimiter" />
			</xsl:for-each>
			<xsl:for-each select="distinct-values(current-group()/person/@ref)">
				<xsl:variable name="child-id" select="." />
				<xsl:value-of select="current-grouping-key()" /><xsl:text> -> </xsl:text><xsl:value-of select="$child-id" /><xsl:value-of select="$statement-delimiter" />
				<xsl:for-each select="distinct-values(current-group()[person/@ref = $child-id]/location/@ref)">
					<xsl:value-of select="$child-id" /><xsl:text> -> </xsl:text><xsl:value-of select="." /><xsl:value-of select="$statement-delimiter" />
				</xsl:for-each>
			</xsl:for-each>	
		</xsl:for-each-group>
	</xsl:template>
	
	<xsl:template match="data/locations">
		<xsl:apply-templates select="location[@id = /data/events/event[@type = 'birth']/location/@ref]" />
	</xsl:template>
	
	<xsl:template match="location[@id]">
		<xsl:value-of select="@id" /><xsl:text> [</xsl:text><xsl:text>label = "</xsl:text><xsl:value-of select="name" /><xsl:text>" shape=circle style=filled fillcolor=black fontcolor=white]</xsl:text><xsl:value-of select="$statement-delimiter" />
	</xsl:template>

</xsl:stylesheet>
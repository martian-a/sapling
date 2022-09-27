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
    
    <xsl:import href="shared.xsl" />
    
    <xsl:template match="/">
    	<xsl:variable name="html-document-title" as="xs:string">Consistency Check: Location Names</xsl:variable>
        <html>
        	<xsl:apply-templates select="/" mode="html-head">
        		<xsl:with-param name="title" select="$html-document-title" as="xs:string" />
        	</xsl:apply-templates>
        	<body>
        		<h1><xsl:value-of select="$html-document-title" /></h1>
        		<xsl:for-each-group select="data/locations/location" group-by="name">
        			<div class="location" id="{@id}">
        				<h2><xsl:value-of select="name" /></h2>        					
        				<xsl:variable name="associated-people-ids" select="distinct-values(/data/events/event[location/@ref = current-group()/@id]/person/@ref)" as="xs:string*" />
        				<xsl:if test="count($associated-people-ids) > 0">
        					<ul class="associated-people">
        						<xsl:for-each select="/data/people/person[@id = $associated-people-ids]">
        							<li><xsl:apply-templates select="self::person" mode="href-html" /></li>
        						</xsl:for-each>
        					</ul>
        				</xsl:if>
        			</div>
        		</xsl:for-each-group> 				
        	</body>
        </html>           	     
    </xsl:template>       

	<xsl:template match="person" mode="href-html">
		<xsl:apply-templates select="persona[1]" mode="#current" />
	</xsl:template>
	
	<xsl:template match="persona" mode="href-html">
		<a href="https://www.ancestry.co.uk/family-tree/person/tree/{$tree-id}/person/{substring-after(ancestor::person[1]/@id, 'I')}/facts"><xsl:value-of select="string-join(name/*, ' ')" /></a>		
	</xsl:template>
	
</xsl:stylesheet>

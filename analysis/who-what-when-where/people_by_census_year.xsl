<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bio="http://purl.org/vocab/bio/0.1/"
    xmlns:dc="http://purl.org/dc/terms/"
    xmlns:digest="http://nwalsh.com/xslt/ext/com.nwalsh.xslt.Digest"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml"
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
    xmlns:temp="http://ns.thecodeyard.co.uk/temp"
    xmlns:time="http://www.w3.org/2006/time#"    
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs fn functx digest"
    version="3.0">    
    
	<xsl:param name="resource-base-uri" select="concat('http://ns.thecodeyard.co.uk/data/sapling/', /*/prov:document/@xml:id)" />
    <xsl:param name="census-year" select="'1841'" />
    
    <xsl:import href="shared.xsl" />
    
	<xsl:variable name="statement-delimiter" select="codepoints-to-string((59, 10))"/>
     
    <xsl:output indent="yes" encoding="UTF-8" method="html" version="5" />
      
    <xsl:key name="child-locations" match="//location[@id]" use="within/@ref" />
	<xsl:key name="parent-location" match="//location[@id]" use="@id" /> 
	
	<doc:doc>
		<doc:title>Key: Person</doc:title>
		<doc:desc>
			<doc:p>For quickly finding an person entity in the data, using it's ID.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="person" match="/data/people/person" use="@id" />
	
	
      
	<xsl:template match="/">
		<xsl:variable name="html-document-title" as="xs:string" select="concat('People by Census Year: ', $census-year)" />
		<html>
			<xsl:apply-templates select="/" mode="html-head">
				<xsl:with-param name="title" select="$html-document-title" as="xs:string" />
			</xsl:apply-templates>
			<body>
				<h1><xsl:value-of select="$html-document-title" /></h1>
				<xsl:apply-templates select="data/people" />   
			</body>
		</html>                
	</xsl:template>      
	
	
	<xsl:template match="people">
		<ul class="people">
			<li>
				<h2>No Estimated Birth Year</h2>
				<ul>
					<xsl:apply-templates select="person[normalize-space(@year) = '']/persona">
						<xsl:sort select="string-join(reverse(name/name), ' ')" data-type="text" order="ascending" />						
					</xsl:apply-templates>
				</ul>
			</li>	
			<xsl:variable name="min-year" select="xs:integer($census-year) - 100" as="xs:integer" />
			<xsl:variable name="max-year" select="xs:integer($census-year) + 5" as="xs:integer" />
			<xsl:variable name="candidates" select="person[normalize-space(@year) != ''][xs:integer(@year) &gt;= $min-year][xs:integer(@year) &lt;= $max-year]" as="element()*" />
			<xsl:for-each-group select="$candidates/persona" group-by="name/name[@family = 'yes']">
				<xsl:sort select="current-grouping-key()" data-type="text" order="ascending" />	
				<li>
					<h2><xsl:value-of select="current-grouping-key()" /></h2>
					<ul>
						<xsl:apply-templates select="current-group()">
							<xsl:sort select="string-join(reverse(name/name), ' ')" data-type="text" order="ascending" />	
							<xsl:sort select="parent::person/@year" data-type="number" order="ascending" />	
						</xsl:apply-templates>
					</ul>
				</li>							
			</xsl:for-each-group>
		</ul>		
	</xsl:template>
	
	<xsl:template match="persona">
		<li><span class="name"><xsl:apply-templates select="self::*" mode="href-html" /></span> (~<xsl:value-of select="if (parent::person/@year) then (xs:integer($census-year) - xs:integer(parent::person/@year)) else '?'" />, <xsl:value-of select="(/data/locations/location[@id = key('birth', current()/parent::person/@id)/location/@ref]/name, '?')[1]" />)</li>
	</xsl:template>

</xsl:stylesheet>
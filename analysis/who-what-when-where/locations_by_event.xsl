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
    
	<xsl:import href="shared.xsl" />
    
	<xsl:variable name="statement-delimiter" select="codepoints-to-string((59, 10))"/>
     
    <xsl:output indent="yes" encoding="UTF-8" method="html" version="5" />
	
    <xsl:template match="/">
    	<xsl:variable name="html-document-title" as="xs:string">Locations by Event</xsl:variable>
        <html>
			<xsl:apply-templates select="/" mode="html-head">
				<xsl:with-param name="title" select="$html-document-title" as="xs:string" />
			</xsl:apply-templates>
        	<body>
        		<h1><xsl:value-of select="$html-document-title" /></h1>
        		<ul>
	        		<xsl:apply-templates select="data/locations/location[@id]">
	        			<xsl:sort select="count(/data/events/event[location/@ref = current()/@id])" data-type="number" order="descending" />
	        		</xsl:apply-templates>
        		</ul>
        	</body>
        </html>                
    </xsl:template>       
	
	<xsl:template match="location">		
		<h2><xsl:apply-templates select="name" /></h2>			
		<xsl:apply-templates select="/data/events">
			<xsl:with-param name="location-id" select="@id" as="xs:string" />
		</xsl:apply-templates>			
	</xsl:template>
	
	<xsl:template match="events">
		<xsl:param name="location-id" as="xs:string" />
		<xsl:variable name="events" select="event[not(@temp:status = 'alternative')][location/@ref = $location-id]" as="element()*" />			
		<p>Total Events: <xsl:value-of select="count($events)" /></p>
		
		<xsl:variable name="partner-events" select="fn:filter-events-for-partner-events($events)" as="element()*" />
		<xsl:if test="$partner-events">
			<div class="partners">
				<h3>Partners</h3>
				<ul>									
					<xsl:for-each-group select="$partner-events" group-by="string-join((if (@type = 'birth') then parent else person)/@ref, '-')">
						<xsl:sort select="date/@year" data-type="number" order="ascending" />
						<xsl:sort select="date/@month" data-type="number" order="ascending" />
						<xsl:sort select="date/@day" data-type="number" order="ascending" />
						<xsl:variable name="partners" select="current-group()[1]/(if (@type = 'birth') then parent else person)/(key('person', @ref))" as="element()*" />
						<li class="partners">
							<p><xsl:for-each select="$partners">
								<xsl:apply-templates select="current()" mode="href-html" />
								<xsl:if test="position() != last()"> and </xsl:if>
							</xsl:for-each></p>
						</li>						
					</xsl:for-each-group>
				</ul>
			</div>
		</xsl:if>
		<xsl:if test="$events">
			<div class="events timeline">
				<h3>Timeline</h3>
				<xsl:apply-templates select="$events" mode="timeline">
					<xsl:sort select="date/@year" data-type="number" order="ascending" />
					<xsl:sort select="date/@month" data-type="number" order="ascending" />
					<xsl:sort select="date/@day" data-type="number" order="ascending" />
				</xsl:apply-templates>
			</div>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
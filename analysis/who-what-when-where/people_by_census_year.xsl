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
    xmlns:guide="http://ns.thecodeyard.co.uk/data/sapling/annotations/guide"
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
	<xsl:param name="name-variants" select="('War', 'Warr', 'Warre', 'Ware', 'Wear')" as="xs:string*" />
    
    <xsl:variable name="numeric-census-year" as="xs:integer?">
    	<xsl:try>
    		<xsl:value-of select="xs:integer($census-year)" />
    		<xsl:catch />
    	</xsl:try>
    </xsl:variable>
	<xsl:variable name="name-variants-sequence" select="if (count($name-variants) = 1) then tokenize(translate($name-variants, concat('()',codepoints-to-string(39)), ''), ',') ! normalize-space(.) else $name-variants" as="xs:string*" />
    
    <xsl:import href="shared.xsl" />
    
	<xsl:variable name="statement-delimiter" select="codepoints-to-string((59, 10))"/>
	<xsl:variable name="min-year" select="$numeric-census-year - 100" as="xs:integer" />
	<xsl:variable name="max-year" select="$numeric-census-year + 5" as="xs:integer" />
     
    <xsl:output indent="yes" encoding="UTF-8" method="html" version="5" />
	
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
			<xsl:variable name="candidates" as="element()*">
				<xsl:variable name="within-date-range" as="element()*">
					<xsl:for-each select="person">
						<!-- xsl:sort select="@guide:birth-year" order="ascending" /-->
						<xsl:variable name="birth-year" select="if (normalize-space(@guide:birth-year) != '') then xs:integer(@guide:birth-year) else ()" as="xs:integer?" />
						<xsl:variable name="death-year" select="if (normalize-space(@guide:death-year) != '') then xs:integer(@guide:death-year) else ()" as="xs:integer?" />
						<xsl:choose>
							<xsl:when test="not($death-year = ())">	
								<xsl:choose>
									<xsl:when test="normalize-space(@guide:birth-year) = ''">
										<xsl:sequence select="self::*" />
									</xsl:when>
									<xsl:otherwise>
										<xsl:sequence select="self::*[$death-year &gt;= $numeric-census-year][$birth-year &gt;= $min-year][$birth-year &lt;= $max-year]" />		
									</xsl:otherwise>
								</xsl:choose>																
							</xsl:when>
							<xsl:when test="not($birth-year = ())">
								<xsl:sequence select="self::*[$birth-year &gt;= $min-year][$birth-year &lt;= $max-year]" />
							</xsl:when>
							<xsl:otherwise>
								<xsl:sequence select="self::*[normalize-space(@guide:birth-year) = ''][normalize-space(@guide:death-year) = '']" />
							</xsl:otherwise>
						</xsl:choose>					
					</xsl:for-each>
				</xsl:variable>
				<xsl:choose>
					<xsl:when test="count($name-variants-sequence) &gt; 0">
						<xsl:for-each select="$within-date-range">
							<xsl:choose>
								<xsl:when test="persona[1][name/name[@family = 'yes']/text() = $name-variants-sequence]">
									<xsl:sequence select="self::*" />
								</xsl:when>
								<xsl:otherwise>
									<xsl:variable name="parent-ids" select="/data/events/event[not(@temp:status = 'alternative')][person/@ref = current()/@id]/parent/@ref" as="xs:string*" />
									<xsl:if test="/data/people/person[@id = $parent-ids]/persona[1]/name/name[@family = 'yes']/text() = $name-variants-sequence">
										<xsl:sequence select="self::*" />
									</xsl:if>
								</xsl:otherwise>
							</xsl:choose>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:sequence select="$within-date-range" />
					</xsl:otherwise>
				</xsl:choose>
			</xsl:variable>
			<xsl:for-each-group select="$candidates/persona" group-by="name/name[@family = 'yes']">
				<xsl:sort select="current-grouping-key()" data-type="text" order="ascending" />	
				<li>
					<h2><xsl:choose>
						<xsl:when test="normalize-space(current-grouping-key()) = ''">No Family Name</xsl:when>
						<xsl:otherwise><xsl:value-of select="current-grouping-key()" /></xsl:otherwise>
					</xsl:choose></h2>
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
		<xsl:variable name="person-id" select="parent::person/@id" as="xs:string" />
		<xsl:variable name="parent-ids" select="/data/events/event[@type = 'birth'][person/@ref = $person-id]/parent/@ref" as="xs:string*" />
		<xsl:variable name="spouse-ids" select="/data/events/event[@type = 'marriage'][person/@ref = $person-id][not(@year) or xs:integer(@year) &lt;= $numeric-census-year]/person[@ref != $person-id]/@ref" as="xs:string*" />
		<xsl:variable name="co-parent-ids" select="/data/events/event[@type = 'birth'][parent/@ref = $person-id][not(@year) or xs:integer(@year) &lt;= $numeric-census-year]/parent[@ref != $person-id]/@ref" as="xs:string*" />
		<xsl:variable name="partner-ids" select="distinct-values(($spouse-ids, $co-parent-ids))" as="xs:string*" />
		<xsl:variable name="child-events" select="/data/events/event[@type = 'birth'][parent/@ref = $person-id][not(@year) or xs:integer(@year) &lt;= $numeric-census-year]" as="element()*" />
		
		<div style="margin: 1em;">
			<table>
				<tr>
					<th class="relationship">Relationship</th>
					<th class="name">Name</th>
					<th class="gender">Gender</th>
					<th class="age">~Age</th>
					<th class="birth-place">~Place of Birth</th>
					<th class="birth-year">~Birth</th>
					<th class="death-year">~Death</th>
					<th class="homes">Homes</th>
				</tr>
				<xsl:for-each select="/data/people/person[@id = $parent-ids][not(@guide:birth-year/xs:integer(.) &lt; $min-year)]">
					<xsl:apply-templates select="persona[1]" mode="table-entry">
						<xsl:sort select="@guide:birth-year" data-type="number" order="ascending" />
						<xsl:with-param name="relationship" select="'Parent'" as="xs:string" />
					</xsl:apply-templates>
				</xsl:for-each>
				<xsl:apply-templates select="self::*" mode="table-entry">
					<xsl:with-param name="relationship" select="'Subject'" as="xs:string" />
				</xsl:apply-templates>
				<xsl:if test="parent::person/@guide:birth-year/xs:integer(.) &lt;= ($numeric-census-year - 12)">
					<xsl:for-each select="/data/people/person[@id = $partner-ids][not(@guide:birth-year) or (@guide:birth-year/xs:integer(.) + 14) &lt;= $max-year]">
						<xsl:variable name="partner-id" select="@id" as="xs:string" />
						<xsl:apply-templates select="persona[1]" mode="table-entry">
							<xsl:with-param name="relationship" select="'Partner'" as="xs:string" />
						</xsl:apply-templates>
						<xsl:variable name="shared-child-ids" select="$child-events[parent/@ref = $partner-id]/person/@ref" as="xs:string*" />
						<xsl:for-each select="/data/people/person[@id = $shared-child-ids][not(@guide:birth-year) or xs:integer(@guide:birth-year) &lt;= $numeric-census-year]">
							<xsl:sort select="@guide:birth-year" data-type="number" order="ascending" />
							<xsl:apply-templates select="persona[1]" mode="table-entry">						
								<xsl:with-param name="relationship" select="'Child'" as="xs:string" />
							</xsl:apply-templates>						
						</xsl:for-each>
					</xsl:for-each>	
					<xsl:variable name="unshared-child-ids" select="$child-events[count(parent) = 1]/person/@ref" as="xs:string*" />
					<xsl:for-each select="/data/people/person[@id = $unshared-child-ids][not(@guide:birth-year) or (@guide:birth-year/xs:integer(.) + 14) &lt;= $max-year]">
						<xsl:sort select="@guide:birth-year" data-type="number" order="ascending" />
						<xsl:apply-templates select="persona[1]" mode="table-entry">						
							<xsl:with-param name="relationship" select="'Child'" as="xs:string" />
						</xsl:apply-templates>	
					</xsl:for-each>			
				</xsl:if>
			</table>
		</div>
	</xsl:template>
	
	
	<xsl:template match="persona" mode="table-entry">
		<xsl:param name="relationship" as="xs:string?" />
		<xsl:variable name="person-id" select="parent::person/@id" as="xs:string?" />
		<xsl:variable name="status" as="xs:string">
			<xsl:choose>
				<xsl:when test="parent::person/@guide:death-year">
					<xsl:choose>
						<xsl:when test="parent::person/@guide:death-year/xs:integer(.) &gt;= $numeric-census-year">probably-alive</xsl:when>
						<xsl:otherwise>probably-dead</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:when test="parent::person/@guide:birth-year">
					<xsl:choose>
						<xsl:when test="parent::person/@guide:birth-year/xs:integer(.) &lt; $min-year">probably-dead</xsl:when>
						<xsl:otherwise>probably-alive</xsl:otherwise>
					</xsl:choose>
				</xsl:when>
				<xsl:otherwise>unknown</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<tr class="status-{$status} {lower-case($relationship)}">
			<td class="relationship"><xsl:value-of select="$relationship" /></td>
			<td class="name"><xsl:choose>
				<xsl:when test="$status = 'probably-dead'"><s><xsl:apply-templates select="self::*" mode="href-html" /></s></xsl:when>
				<xsl:otherwise><xsl:apply-templates select="self::*" mode="href-html" /></xsl:otherwise>
			</xsl:choose></td>
			<td class="gender"><xsl:value-of select="substring(gender, 1, 1)" /></td>
			<td class="age"><xsl:value-of select="if (parent::person/@guide:birth-year) then ($numeric-census-year - xs:integer(parent::person/@guide:birth-year)) else '?'" /></td>
			<td class="birth-place"><xsl:value-of select="if (parent::person/@guide:birth-location-id) then parent::person/key('location', @guide:birth-location-id)/name else '?'" /></td>
			<td class="birth-year"><xsl:value-of select="parent::person/@guide:birth-year" /></td>
			<td class="death-year"><xsl:value-of select="parent::person/@guide:death-year" /></td>
			<td class="homes">
				<xsl:variable name="homes" as="element()*">
					<xsl:for-each select="distinct-values(/data/events/event[@type = 'residence'][@person/@ref = $person-id]/location/@ref)">
						<xsl:sequence select="/data/locations/location[@id = current()]/name" />				
					</xsl:for-each>
				</xsl:variable>
				<xsl:value-of select="string-join($homes, '; ')" />
			</td>
		</tr>
	</xsl:template>

</xsl:stylesheet>
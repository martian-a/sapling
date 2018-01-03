<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	exclude-result-prefixes="#all"
	version="2.0">
	
	<doc:doc>
		<doc:desc>
			<doc:p>Filter source data, preparing it for distribution.</doc:p>
			<doc:ul>
				<doc:ingress>Actions include:</doc:ingress>
				<doc:li>exclude person records that aren't yet ready for publishing</doc:li>
				<doc:li>exclude event records that aren't related to a publishable person</doc:li>
				<doc:li>exclude organisation records that aren't related to a publishable person or event</doc:li>
				<doc:li>exclude location records that aren't related to a publishable person, event or organisation</doc:li>
				<doc:li>anonymise or remove cross-references to person records that aren't yet ready for publishing</doc:li>
			</doc:ul>
		</doc:desc>
	</doc:doc>
	
	
	
	
	<doc:doc>
		<doc:title>Key: Location within</doc:title>
		<doc:desc>
			<doc:p>For quickly finding location entities that are within a specified location.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:key name="location-within" match="data/locations/location" use="within/@ref" />
	
	
	<xsl:preserve-space elements="*" />
	
	<doc:doc>
		<doc:title>Initial template</doc:title>
		<doc:desc>
			<doc:p>Match the document root and initiate transformation.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="/">
		<xsl:result-document>
			<xsl:apply-templates />
		</xsl:result-document>
	</xsl:template>	
	
	
	<xsl:template match="/app/data">
		
		<xsl:variable name="first-pass" as="document-node()">
			<xsl:document>
				<xsl:call-template name="filter-data-by-people-to-be-published">
					<xsl:with-param name="people" select="people/person[@publish = 'true']" as="element()*" tunnel="yes" />
					<xsl:with-param name="data" select="self::data" as="element()" />
				</xsl:call-template>
			</xsl:document>
		</xsl:variable>
		
		
		<xsl:variable name="core-network-people" as="element()*">
			<xsl:variable name="network-graph" as="document-node()">
				<xsl:document>
					<network>
						<nodes>
							<xsl:apply-templates select="$first-pass/data/people/person" mode="network-graph" />
						</nodes>
						<edges>
							<xsl:apply-templates select="$first-pass/data/events/event[count(descendant::*/@ref[starts-with(., 'PER')]) &gt; 1]" mode="network-graph" />
						</edges>
					</network>
				</xsl:document>
			</xsl:variable>
			
			<xsl:variable name="clusters" as="document-node()">
				<xsl:document>
					<clusters>
						<xsl:sequence select="fn:consolidate-clusters(fn:adjacent-nodes($network-graph/network))" />
					</clusters>
				</xsl:document>
			</xsl:variable>			
			
			<xsl:variable name="largest-cluster" as="element()*">
				<xsl:for-each select="$clusters/clusters/cluster">
					<xsl:sort select="count(*)" data-type="number" order="descending" />
					<xsl:if test="position() = 1">
						<xsl:sequence select="self::cluster" />
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
					
			<xsl:copy-of select="$first-pass/data/people/person[@id = $largest-cluster/node/@ref]" />
		
		</xsl:variable>	
					
		
		<xsl:call-template name="filter-data-by-people-to-be-published">
			<xsl:with-param name="people" select="$core-network-people" as="element()*" tunnel="yes" />
			<xsl:with-param name="data" select="$first-pass/data" as="element()" />
		</xsl:call-template>
		
	</xsl:template>
	
	<xsl:template name="filter-data-by-people-to-be-published">
		<xsl:param name="people" as="element()*" tunnel="yes" />
		<xsl:param name="data" as="element()" />
		
		<!-- A look-up list of all events that shoudn't be published because they don't involve a published person. -->
		<xsl:variable name="unpublished-events" as="element()*">
			<xsl:for-each select="$data/events/event">
				<xsl:variable name="references-to-people" select="descendant::*[@ref = $people/@id]" as="element()*" />
				<xsl:if test="count($references-to-people) = 0">
					<xsl:sequence select="self::*" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- A look-up list of all organisations that shoudn't be published because they don't involve a published person, either directly or indirectly via a cross-reference. -->
		<xsl:variable name="unpublished-organisations" as="element()*">
			<xsl:for-each select="$data/organisations/organisation">
				<xsl:variable name="references-from-published-entities" as="element()*">
					
					<!-- references from published people -->
					<xsl:sequence select="$people/descendant::organisation[@ref = current()/@id]" />
					
					<!-- references from published events -->
					<xsl:sequence select="$data/events/event[not(@id = $unpublished-events/@id)]/descendant::organisation[@ref = current()/@id]" />
				</xsl:variable>
				
				<xsl:if test="count($references-from-published-entities) = 0">
					<xsl:sequence select="self::*" />
				</xsl:if>
			</xsl:for-each>
		</xsl:variable>
		
		<!-- A look-up list of all locations that shoudn't be published because they don't involve a published person, either directly or indirectly via a cross-reference. -->
		<xsl:variable name="unpublished-locations" as="element()*">
			<xsl:variable name="lacks-direct-reference" as="element()*">
				<xsl:for-each select="$data/locations/location">
					
					<xsl:variable name="locations-within" select="fn:get-locations-within(self::location)" as="element()*" />
					
					<xsl:variable name="references-from-published-entities" as="element()*">
						
						<!-- references from published people -->
						<xsl:sequence select="$people/descendant::location[@ref = (current()/@id, $locations-within/@id)]" />
						
						<!-- references from published events -->
						<xsl:sequence select="$data/events/event[not(@id = $unpublished-events/@id)]/descendant::location[@ref = (current()/@id, $locations-within/@id)]" />
						
						<!-- references from published organisations -->
						<xsl:sequence select="$data/organisations/organisation[not(@id = $unpublished-organisations/@id)]/descendant::location[@ref = (current()/@id, $locations-within/@id)]" />
						
					</xsl:variable>
					
					<xsl:if test="count($references-from-published-entities) = 0">
						<xsl:sequence select="self::*" />
					</xsl:if>
				</xsl:for-each>
			</xsl:variable>
			
			<xsl:variable name="has-direct-reference" select="$data/locations/location[not(@id = $lacks-direct-reference/@ref)]" as="element()*" />
			<xsl:sequence select="$lacks-direct-reference[not(@id = $has-direct-reference/descendant::near/@ref)]" />
		</xsl:variable>
		
		<xsl:copy>
			<xsl:apply-templates select="@*" />	
			<xsl:apply-templates select="$data/node()">
				<xsl:with-param name="unpublished-events" select="$unpublished-events" as="element()*" tunnel="yes" />
				<xsl:with-param name="unpublished-organisations" select="$unpublished-organisations" as="element()*" tunnel="yes" />
				<xsl:with-param name="unpublished-locations" select="$unpublished-locations" as="element()*" tunnel="yes" />
			</xsl:apply-templates>
		</xsl:copy>
		
	</xsl:template>

	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress person records that aren't explicitly set to publish.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="person[@id]">
		<xsl:param name="people" as="element()*" tunnel="yes" />
		
		<xsl:if test="@id = $people/@id">
			<xsl:next-match />
		</xsl:if>
	</xsl:template>	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress references to person records that aren't explicitly set to publish.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="person[@ref]">
		<xsl:param name="people" as="element()*" tunnel="yes" />
		
		<xsl:choose>
			<xsl:when test="@ref = $people/@id">
				<xsl:next-match />
			</xsl:when>
			<xsl:when test="ancestor::note">
				<xsl:choose>
					<xsl:when test="normalize-space(.) = ''">[name witheld]"</xsl:when>
					<xsl:otherwise><xsl:value-of select="." /></xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise />
		</xsl:choose>
	</xsl:template>	

	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress event records that don't invovle a person who isn't explicitly set to publish.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="event[@id]">
		<xsl:param name="unpublished-events" as="element()*" tunnel="yes" />
		
		<xsl:if test="not(@id = $unpublished-events/@id)">
			<xsl:next-match />
		</xsl:if>
	</xsl:template>	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress organisation records that don't involve a person who isn't explicitly set to publish</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="organisation[@id]">
		<xsl:param name="unpublished-organisations" as="element()*" tunnel="yes" />
		
		<xsl:if test="not(@id = $unpublished-organisations/@id)">
			<xsl:next-match />
		</xsl:if>
	</xsl:template>	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Suppress location records that don't involve a person who isn't explicitly set to publish.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="location[@id]">
		<xsl:param name="unpublished-locations" as="element()*" tunnel="yes" />
		
		<xsl:if test="not(@id = $unpublished-locations/@id)">
			<xsl:next-match />
		</xsl:if>
	</xsl:template>	
	
	
	
	<xsl:template match="people/person" mode="network-graph">
		<node id="{@id}">
			<xsl:value-of select="persona[1]/name/string-join(*, ' ')" />
		</node>
	</xsl:template>
	
	<xsl:template match="temp/*" mode="network-graph">
		<node ref="{@ref}" />
	</xsl:template>
	
	<xsl:template match="event" mode="network-graph">
		<xsl:variable name="event-id" select="@id" as="xs:string" />
		<xsl:variable name="people" as="document-node()">
			<xsl:document>
				<temp>
					<xsl:for-each-group select="descendant::*[name() = ('parent', 'person')][@ref]" group-by="@ref">
						<xsl:copy-of select="current-group()[1]" />
					</xsl:for-each-group>
				</temp>
			</xsl:document>
		</xsl:variable>
		
		<xsl:for-each select="$people/temp/*">
			<xsl:variable name="person" select="self::*" as="element()" />
			
			<xsl:for-each select="$person/following-sibling::*">
				<xsl:variable name="other-person" select="self::*" as="element()" />
				<xsl:variable name="id" select="concat($event-id, '-', $person/@ref, '-', $other-person/@ref)" as="xs:string" />
				
				<edge id="{$id}" length="1">
					<xsl:apply-templates select="$person" mode="#current" />
					<xsl:apply-templates select="$other-person" mode="#current" />
				</edge>
			</xsl:for-each>
			
		</xsl:for-each>
		
	</xsl:template>

	
	
	<doc:doc>
		<doc:title>Identity Transform: Element</doc:title>
		<doc:desc>
			<doc:p>Match and copy and element node.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="*">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()"/>
		</xsl:copy>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Identity Transform: Attribute, Comment or Processing Instruction</doc:title>
		<doc:desc>
			<doc:p>Match and deep copy an attribute, comment or processing instruction.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="@* | comment() | processing-instruction()">
		<xsl:copy-of select="." />
	</xsl:template>
	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Return a list of all the locations within a specified location.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:function name="fn:get-locations-within" as="element()*">
		<xsl:param name="location-in" as="element()" />
		
		<xsl:for-each select="$location-in/key('location-within', @id)">
			<xsl:sequence select="current()" /> 
			<xsl:sequence select="fn:get-locations-within(current())" />
		</xsl:for-each>
		
	</xsl:function>
	
	
	<xsl:function name="fn:adjacent-nodes" as="element()">
		<xsl:param name="network" as="element()" />
		
		<network>
			<xsl:for-each select="$network/nodes/node">
				<xsl:variable name="self" select="self::node" as="element()" />
				
				<xsl:variable name="cluster" as="element()">        
					<cluster>
						<node ref="{$self/@id}" />
						<xsl:sequence select="fn:get-connected-nodes($self)" />
					</cluster>
				</xsl:variable>
				
				<xsl:sequence select="fn:dedupe-clusters($cluster)" />
				
			</xsl:for-each>
		</network>
	</xsl:function>
	
	
	<xsl:function name="fn:get-connected-nodes" as="element()*">
		<xsl:param name="subject" as="element()" />
		
		<xsl:sequence select="$subject/ancestor::network/edges/edge[node/@ref = $subject/(@id | @ref)]/node" />
		
	</xsl:function>    
	
	
	<xsl:function name="fn:dedupe-clusters" as="element()*">
		<xsl:param name="clusters-in" as="element()*" />
		
		<xsl:for-each select="$clusters-in/self::cluster">
			<xsl:copy>
				<xsl:copy-of select="@*" />
				<xsl:for-each select="node[not(@ref = preceding-sibling::node/@ref)]">
					<xsl:copy-of select="self::node" />
				</xsl:for-each>
			</xsl:copy>
		</xsl:for-each>
	</xsl:function>
	
	
	
	<doc:doc>
		<doc:desc>
			<doc:p>Return a list of clusters of nodes that have a direct relationship to each other.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:function name="fn:consolidate-clusters" as="element()*">
		<xsl:param name="network-in" as="element()" />
		
		<xsl:variable name="single-pass" as="element()">
			<network>
				<xsl:sequence select="fn:consolidate-clusters-single-pass($network-in)" />
			</network>
		</xsl:variable>    
		
		<xsl:variable name="overlap" select="fn:clusters-overlap($single-pass)" as="xs:boolean" />
		
		<xsl:choose>
			<xsl:when test="$overlap">
				<xsl:sequence select="fn:consolidate-clusters($single-pass)" />            
			</xsl:when>
			<xsl:otherwise> 
				<xsl:sequence select="$single-pass/cluster" />
			</xsl:otherwise>
		</xsl:choose> 
		
	</xsl:function>
	
	<xsl:function name="fn:consolidate-clusters-single-pass" as="element()*">
		<xsl:param name="network-in" as="element()" />
		
		<xsl:variable name="merged" as="element()*">
			<xsl:for-each select="$network-in/cluster[node/@ref = following-sibling::cluster/node/@ref][1]">
				<xsl:variable name="current" select="self::cluster/node" as="element()*" />
				<xsl:copy>
					<xsl:copy-of select="@*, node()" />
					<xsl:copy-of select="following-sibling::cluster[node/@ref = $current/@ref]/node" />
				</xsl:copy>
			</xsl:for-each>
		</xsl:variable>
		
		<xsl:sequence select="fn:dedupe-clusters($merged)" />  
		
		<xsl:for-each select="$network-in/cluster[node[not(@ref = $merged/node/@ref)]]">
			<xsl:copy-of select="self::cluster" />
		</xsl:for-each>
		
	</xsl:function>
	
	<xsl:function name="fn:clusters-overlap" as="xs:boolean">
		<xsl:param name="network-in" as="element()" />
		
		<xsl:variable name="overlap" as="element()*">
			
			<xsl:for-each select="$network-in/cluster">
				<xsl:variable name="self" select="self::cluster" as="element()" />
				<xsl:if test="preceding-sibling::cluster[node/@ref = $self/node/@ref]">
					<xsl:copy-of select="self::cluster" />
				</xsl:if>
			</xsl:for-each>
			
		</xsl:variable>
		
		<xsl:choose>
			<xsl:when test="count($overlap) &gt; 0">
				<xsl:value-of select="true()" />            
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="false()" />
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
	
</xsl:stylesheet>
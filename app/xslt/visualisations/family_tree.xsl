<xsl:stylesheet 	
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
		
	<xsl:import href="network_graph.xsl" />
	
	
	<xsl:template match="/app">
		
		<xsl:variable name="network" as="element()">
			<xsl:apply-templates select="view/data/person/related" mode="family-tree">
				<xsl:with-param name="subject" select="view/data/person" as="element()" tunnel="yes" />
			</xsl:apply-templates>
		</xsl:variable>
		
		<xsl:apply-templates select="$network" mode="network-graph.serialise" />
		
	</xsl:template>
	
	
	<xsl:template match="related" mode="family-tree" priority="10">
			
		<xsl:variable name="may-contain-duplicates" as="element()*">
			<xsl:apply-templates select="self::*" mode="family-tree.objects" />
		</xsl:variable>
		
		<xsl:call-template name="network-graph">
			<xsl:with-param name="config" as="element()">
				<config>
					<settings scope="global">
						<xsl:text>graph [fontname = "IM FELL DW Pica"];&#10;</xsl:text>
						<!-- Global node settings -->
						<xsl:text>node [fontname = "IM FELL DW Pica", shape = none, fillcolor = "#f5f5f5"];&#10;</xsl:text>
						<!-- Global edge settings -->
						<xsl:text>edge [fontname = "IM FELL DW Pica"];&#10;</xsl:text>
					</settings>
					<rank direction="{$graph-direction}" />
				</config>
			</xsl:with-param>
			<xsl:with-param name="node-data" as="element()*">
				<xsl:for-each-group select="$may-contain-duplicates[@type = 'node']" group-by="property[@label = 'id']">
					<xsl:sequence select="current-group()[1]" />
				</xsl:for-each-group>
			</xsl:with-param>
			<xsl:with-param name="edge-data" as="element()*">
				<xsl:for-each-group select="$may-contain-duplicates[@type = 'edge']" group-by="concat(property[@label = 'from'], property[@label = 'to'])">
					<xsl:sequence select="current-group()[1]" />
				</xsl:for-each-group>
			</xsl:with-param>
			<xsl:with-param name="stored-layout" select="if (parent::person[@x][@y]) then true() else false()" as="xs:boolean" />
		</xsl:call-template>
		
	</xsl:template>
	

	<doc:doc>
		<doc:title>Nodes</doc:title>
		<doc:desc>
			<doc:p>Create a node for each entity in the graph.</doc:p>
		</doc:desc>
	</doc:doc>
	<xsl:template match="related" mode="family-tree.objects">
		<xsl:param name="subject" as="element()" tunnel="yes" />
		
		<!-- Sorted in chronological order -->
		<xsl:variable name="subject-birth-events" select="fn:get-birth-events($subject)" as="element()*" />
		
		<!-- Sorted in chronological order -->
		<xsl:variable name="partner-events" select="fn:get-partner-events($subject)" as="element()*" />
		
		<!-- Subject's parent's -->
		<xsl:for-each-group select="$subject-birth-events[parent]" group-by="fn:get-inferred-relationship-id(current())">
			<xsl:sort select="date/@year" data-type="number" order="ascending" />
			<xsl:sort select="date/@month" data-type="number" order="ascending" />
			<xsl:sort select="date/@day" data-type="number" order="ascending" />
			
			<xsl:variable name="parents-in-group" select="current-group()/fn:get-sorted-parents(self::event)" as="element()*" />
			<xsl:variable name="node-id" select="current-grouping-key()" as="xs:string" />
			<xsl:variable name="level" select="1" as="xs:integer" />
			<xsl:variable name="mid-point" select="if (count($parents-in-group) &lt; 2) then 1 else floor(count($parents-in-group) div 2)" as="xs:integer" />
			
			<xsl:for-each select="$parents-in-group">
			
				<!-- Node: Parent -->
				<xsl:apply-templates select="self::parent" mode="family-tree.node">
					<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
				</xsl:apply-templates>
				
				<xsl:if test="count($parents-in-group) > 1">
				
					<!-- Node: Relationship between parents -->
					<xsl:if test="position() = $mid-point">
						<xsl:call-template name="partner-relationship">
							<xsl:with-param name="partners-in-relationship" select="$parents-in-group" as="element()*" />
							<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
							<xsl:with-param name="node-id" select="$node-id" as="xs:string" />
						</xsl:call-template>				
					</xsl:if>
			
					<!-- Edge: Between parent and relationship -->
					<xsl:choose>
						<xsl:when test="position() &gt; $mid-point">
							<xsl:apply-templates select="self::parent" mode="family-tree.edge">
								<xsl:with-param name="from" select="$node-id" as="xs:string" tunnel="yes" />
							</xsl:apply-templates>
						</xsl:when>
						<xsl:otherwise>
							<xsl:apply-templates select="self::parent" mode="family-tree.edge">
								<xsl:with-param name="to" select="$node-id" as="xs:string" tunnel="yes" />
							</xsl:apply-templates>
						</xsl:otherwise>
					</xsl:choose>	
				</xsl:if>
				
			</xsl:for-each>
			
			<!-- Edge: Subject from relationship -->
			<xsl:apply-templates select="$subject" mode="family-tree.edge">
				<xsl:with-param name="from" select="$node-id" as="xs:string" tunnel="yes" />
			</xsl:apply-templates>
			
		</xsl:for-each-group>
		
		
		<xsl:choose>
			
			<!-- Subject has no known partners -->
			<xsl:when test="count($partner-events) = 0">
				
				<!-- Subject -->
				<xsl:apply-templates select="$subject" mode="family-tree.node">
					<xsl:with-param name="level" select="2" as="xs:integer" tunnel="yes" />
				</xsl:apply-templates>
				
				<!-- Children -->
				<xsl:for-each-group select="fn:get-birth-events($subject, 'parent')/person/key('person', @ref)" group-by="@id">
					<xsl:sort select="@year" data-type="number" order="ascending" />
					<xsl:sort select="fn:get-sort-name(self::person)" data-type="text" order="ascending" />
					
					<xsl:variable name="child" select="current-group()[1]" as="element()" />
					
					<!-- Node: Child (whose only known parent is the subject) -->
					<xsl:apply-templates select="$child" mode="family-tree.node">
						<xsl:with-param name="level" select="3" as="xs:integer" tunnel="yes" />
					</xsl:apply-templates>
					
					<!-- Edge: Child (whose only known parent is the subject) -->
					<xsl:apply-templates select="$child" mode="family-tree.edge">
						<xsl:with-param name="from" select="$subject/@id" as="xs:string" tunnel="yes" />
					</xsl:apply-templates>
					
				</xsl:for-each-group>
				
			</xsl:when>
			
			<!-- Subject has known partners -->
			<xsl:otherwise>
				
				<!-- Subject's relationships -->
				<xsl:for-each-group select="$partner-events" group-by="fn:get-inferred-relationship-id(current())">
					<xsl:sort select="date/@year" data-type="number" order="ascending" />
					<xsl:sort select="date/@month" data-type="number" order="ascending" />
					<xsl:sort select="date/@day" data-type="number" order="ascending" />
					
					<xsl:variable name="partners-in-group" as="element()*">
						<xsl:variable name="unsorted" as="element()*">
							<xsl:choose>
								<xsl:when test="current-group()[1]/@type = $parental-relationship-types">
									<xsl:sequence select="current-group()[1]/parent/key('person', @ref)" />					
								</xsl:when>
								<xsl:otherwise>
									<xsl:sequence select="current-group()[1]/person/key('person', @ref)" />
								</xsl:otherwise>
							</xsl:choose>
						</xsl:variable>
						<xsl:for-each select="$unsorted">
							<xsl:sort select="@year" data-type="number" order="ascending" />
							<xsl:sort select="fn:get-sort-name(self::person)" data-type="text" order="ascending" />
							<xsl:sequence select="current()" />
						</xsl:for-each>
					</xsl:variable>
					<xsl:variable name="node-id" select="current-grouping-key()" as="xs:string" />
					<xsl:variable name="level" select="2" as="xs:integer" />
					<xsl:variable name="mid-point" select="floor(count($partners-in-group) div 2)" as="xs:integer" />
					
					<xsl:for-each select="$partners-in-group">
						
						<!-- Node: Partner -->
						<xsl:apply-templates select="self::*" mode="family-tree.node">
							<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
						</xsl:apply-templates>
						
						<!-- Node: Relationship between partners -->
						<xsl:if test="position() = $mid-point">
							
							<xsl:call-template name="partner-relationship">
								<xsl:with-param name="partners-in-relationship" select="$partners-in-group" as="element()*" />
								<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
								<xsl:with-param name="node-id" select="current-grouping-key()" as="xs:string" />
							</xsl:call-template>
							
						</xsl:if>
						
						<!-- Edge: Between partner and relationship -->
						<xsl:choose>
							<xsl:when test="position() &gt; $mid-point">
								<xsl:apply-templates select="self::*" mode="family-tree.edge">
									<xsl:with-param name="from" select="$node-id" as="xs:string" tunnel="yes" />
								</xsl:apply-templates>
							</xsl:when>
							<xsl:otherwise>
								<xsl:apply-templates select="self::*" mode="family-tree.edge">
									<xsl:with-param name="to" select="$node-id" as="xs:string" tunnel="yes" />
								</xsl:apply-templates>								
							</xsl:otherwise>
						</xsl:choose>
						
					</xsl:for-each>
					
					
					<!-- Children whose only known parent is the subject -->
					<xsl:if test="position() = 1">
						<xsl:for-each-group select="fn:get-birth-events($subject, 'parent')[count(parent) = 1]/person/key('person', @ref)" group-by="@id">
							<xsl:sort select="@year" data-type="number" order="ascending" />
							<xsl:sort select="fn:get-sort-name(self::person)" data-type="text" order="ascending" />
							
							<xsl:variable name="child" select="current-group()[1]" as="element()" />
							
							<!-- Node: Child (whose only known parent is the subject) -->
							<xsl:apply-templates select="$child" mode="family-tree.node">
								<xsl:with-param name="level" select="3" as="xs:integer" tunnel="yes" />
							</xsl:apply-templates>
							
							<!-- Edge: Child (whose only known parent is the subject) -->
							<xsl:apply-templates select="$child" mode="family-tree.edge">
								<xsl:with-param name="from" select="$subject/@id" as="xs:string" tunnel="yes" />
							</xsl:apply-templates>
							
						</xsl:for-each-group>
					</xsl:if>
					
					<!-- Children from relationship -->
					<xsl:for-each-group select="fn:get-events-involving-people($partners-in-group)[@type = $parental-relationship-types][parent/@ref = $partners-in-group/(@ref | @id)]/person/key('person', @ref)" group-by="@id">
						<xsl:sort select="@year" data-type="number" order="ascending" />
						<xsl:sort select="fn:get-sort-name(self::person)" data-type="text" order="ascending" />
					
						<xsl:variable name="child" select="current-group()[1]" as="element()" />
					
						<!-- Node: Child (who has a known parent who isn't the subject) -->
						<xsl:apply-templates select="current-group()[1]" mode="family-tree.node">
							<xsl:with-param name="level" select="3" as="xs:integer" tunnel="yes" />
						</xsl:apply-templates>
						
						<!-- Edge: Child (who has a known parent who isn't the subject) -->
						<xsl:apply-templates select="$child" mode="family-tree.edge">
							<xsl:with-param name="from" select="$node-id" as="xs:string" tunnel="yes" />
						</xsl:apply-templates>
						
					</xsl:for-each-group>
					
				</xsl:for-each-group>
				
			</xsl:otherwise>
			
		</xsl:choose>
		
	</xsl:template>
	
	<doc:doc>
		<doc:title>Create Node: Partner relationship</doc:title>
	</doc:doc>
	<xsl:template name="partner-relationship">
		<xsl:param name="node-id" as="xs:string" />
		<xsl:param name="partners-in-relationship" as="element()*" />
		
		<xsl:variable name="partner-events" select="fn:get-events-involving-people($partners-in-relationship)[@type = $romantic-relationship-types]" as="element()*" />
		
		<xsl:call-template name="network-graph.node">
			<xsl:with-param name="id" select="$node-id" as="xs:string" />
			<xsl:with-param name="label" as="node()*">

				<xsl:choose>
					<xsl:when test="$partner-events[@type = 'marriage']">
						<xsl:variable name="label-events" select="$partner-events[@type = ('marriage', 'divorce')]" as="element()*" />
						<xsl:for-each-group select="$label-events" group-starting-with="@type[. = 'marriage']">
							<xsl:sort select="date/@year" data-type="number" order="ascending" />
							<xsl:sort select="date/@month" data-type="number" order="ascending" />
							<xsl:sort select="date/@day" data-type="number" order="ascending" />
							
							<xsl:for-each-group select="current-group()" group-ending-with="@type[. = 'divorce']">
								<xsl:for-each select="current-group()">
									<font face="DejaVu Sans"><xsl:choose>
										<xsl:when test="@type = 'marriage'"><xsl:text>⚭</xsl:text></xsl:when>
										<xsl:when test="@type = 'divorce'"><xsl:text>⚮</xsl:text></xsl:when>
									</xsl:choose></font>
									<xsl:if test="count($label-events/date/@year) = 1"><br /></xsl:if>
									<xsl:if test="date/@year != ''">
										<xsl:if test="count($label-events) &gt; 1"><xsl:value-of select="codepoints-to-string(8202)" /></xsl:if>
										<i><xsl:value-of select="date/@year" /></i>
									</xsl:if>
									<xsl:if test="@type = 'marriage' and position() != last()"><xsl:text> – </xsl:text></xsl:if>
								</xsl:for-each>
								<xsl:if test="position() != last()">,<br /></xsl:if>
							</xsl:for-each-group>
							
						</xsl:for-each-group>
					</xsl:when>
					<xsl:when test="$partner-events[@type = 'unmarried-partnership']">
						<xsl:variable name="label-events" select="$partner-events[@type = ('unmarried-partnership', 'separation')]" as="element()*" />
						<xsl:for-each-group select="$label-events" group-starting-with="@type[. = 'unmarried-partnership']">
							<xsl:sort select="date/@year" data-type="number" order="ascending" />
							<xsl:sort select="date/@month" data-type="number" order="ascending" />
							<xsl:sort select="date/@day" data-type="number" order="ascending" />
							
							<xsl:for-each-group select="current-group()" group-ending-with="@type[. = 'separation']">
								<xsl:for-each select="current-group()">
									<font face="DejaVu Sans"><xsl:choose>
										<xsl:when test="@type = 'unmarried-partnership'"><xsl:text>⚯</xsl:text></xsl:when>
										<xsl:when test="@type = 'separation'"><xsl:text>⚮</xsl:text></xsl:when>
									</xsl:choose></font>
									<xsl:if test="count($label-events/date/@year) = 1"><br /></xsl:if>
									<xsl:if test="date/@year != ''">
										<xsl:if test="count($label-events) &gt; 1"><xsl:value-of select="codepoints-to-string(8202)" /></xsl:if>
										<i><xsl:value-of select="date/@year" /></i>
									</xsl:if>
									<xsl:if test="@type = 'unmarried-partnership' and position() != last()"><xsl:text> – </xsl:text></xsl:if>
								</xsl:for-each>
								<xsl:if test="position() != last()">,<br /></xsl:if>
							</xsl:for-each-group>
							
						</xsl:for-each-group>
					</xsl:when>
					<xsl:when test="$partner-events[@type = 'engagement']">
						<xsl:variable name="label-events" select="$partner-events[@type = ('engagement', 'separation')]" as="element()*" />
						<xsl:for-each-group select="$label-events" group-starting-with="@type[. = 'engagement']">
							<xsl:sort select="date/@year" data-type="number" order="ascending" />
							<xsl:sort select="date/@month" data-type="number" order="ascending" />
							<xsl:sort select="date/@day" data-type="number" order="ascending" />
							
							<xsl:for-each-group select="current-group()" group-ending-with="@type[. = 'separation']">
								<xsl:for-each select="current-group()">
									<font face="DejaVu Sans"><xsl:choose>
										<xsl:when test="@type = 'engagement'"><xsl:text>⚬</xsl:text></xsl:when>
										<xsl:when test="@type = 'separation'"><xsl:text>⚮</xsl:text></xsl:when>
									</xsl:choose></font>
									<xsl:if test="count($label-events) = 1"><br /></xsl:if>
									<xsl:if test="date/@year != ''">
										<xsl:if test="count($label-events) &gt; 1"><xsl:value-of select="codepoints-to-string(8202)" /></xsl:if>
										<i><xsl:value-of select="date/@year" /></i>
									</xsl:if>
									<xsl:if test="@type = 'engagement' and position() != last()"><xsl:text> – </xsl:text></xsl:if>
								</xsl:for-each>
								<xsl:if test="position() != last()">,<br /></xsl:if>
							</xsl:for-each-group>
							
						</xsl:for-each-group>
					</xsl:when>
					<xsl:otherwise>
						<font face="DejaVu Sans">⦿</font>
					</xsl:otherwise>
					
				</xsl:choose>
				
			</xsl:with-param>
		</xsl:call-template>
		
	</xsl:template>
	
	
	<xsl:template match="person[@ref] | parent[@ref]" mode="family-tree.node family-tree.edge">
		<xsl:apply-templates select="key('person', @ref)" mode="#current" />
	</xsl:template>
	
	
	<xsl:template match="person[@id]" mode="family-tree.node">
		<xsl:param name="subject" as="element()" tunnel="yes" />
		
		<xsl:call-template name="network-graph.node">
			<xsl:with-param name="id" select="@id" as="xs:string" />
			<xsl:with-param name="label" as="node()*">
				<xsl:value-of select="normalize-space(fn:get-name(self::*))" />
				<xsl:variable name="dated-birth-events" select="fn:get-birth-events(self::*)[date/@year]" as="element()*" />
				<xsl:for-each select="$dated-birth-events[1]">
					<br /><font face="DejaVu Sans">
					<xsl:choose>
						<xsl:when test="@type = 'birth'">☥</xsl:when>
						<xsl:when test="@type = 'christening'">≈</xsl:when>
						<xsl:when test="@type = 'adoption'">💗</xsl:when>
						<xsl:otherwise>~</xsl:otherwise>
					</xsl:choose>
					</font><i><xsl:value-of select="date/@year" /></i>
				</xsl:for-each>
				<xsl:variable name="end-date" select="ancestor::data/person/related/event[@type = ('death')][person/@ref = current()/@id]" />
				<xsl:if test="$end-date/date/@year != ''">
					<xsl:if test="count($dated-birth-events) = 0"><br /></xsl:if>
					<font face="DejaVu Sans"><xsl:if test="count($dated-birth-events) > 0">–</xsl:if>✝</font><i><xsl:value-of select="$end-date/date/@year" /></i>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="style" select="if (@id = $subject/@id) then 'filled' else ()" as="xs:string?" />
			<xsl:with-param name="url" select="xs:anyURI(concat($normalised-path-to-view-html, 'person/', @id, if ($static = 'true') then $ext-html else '/'))" as="xs:anyURI" />
		</xsl:call-template>
	
	</xsl:template>
		
	
	<xsl:template match="person[@id]" mode="family-tree.edge">
		<xsl:param name="from" select="@id" as="xs:string" tunnel="yes" />
		<xsl:param name="to" select="@id" as="xs:string" tunnel="yes" />
		
		<!-- Person to relationship node -->
		<xsl:call-template name="network-graph.edge">
			<xsl:with-param name="from" select="$from" as="xs:string" />
			<xsl:with-param name="to" select="$to" as="xs:string" />
			<xsl:with-param name="length" select="count(fn:get-name(self::*)) + 300" as="xs:integer" />
		</xsl:call-template>
		
	</xsl:template>
	
	
</xsl:stylesheet>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<xsl:import href="../functions.xsl"/>
	<xsl:import href="../defaults.xsl"/>
	<xsl:import href="../view.xsl"/>
	<xsl:import href="serialise.dot.xsl" />
	
	<xsl:param name="path-to-js" select="'../../js/'" as="xs:string"/>
	<xsl:param name="path-to-css" select="'../../css/'" as="xs:string"/>
	<xsl:param name="path-to-view-xml" select="'../xml'" as="xs:string"/>
	<xsl:param name="path-to-view-html" select="'../html'" as="xs:string"/>
	<xsl:param name="path-to-view-svg" select="'../svg'" as="xs:string"/>
	<xsl:param name="path-to-images" select="'../../images'" as="xs:string"/>
	<xsl:param name="static" select="'false'" as="xs:string"/>
	
	<xsl:strip-space elements="*"/>
	
	<xsl:variable name="normalised-path-to-js" select="fn:add-trailing-slash(translate($path-to-js, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-css" select="fn:add-trailing-slash(translate($path-to-css, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-images" select="fn:add-trailing-slash(translate($path-to-images, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-view-xml" select="fn:add-trailing-slash(translate($path-to-view-xml, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-view-html" select="fn:add-trailing-slash(translate($path-to-view-html, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-view-svg" select="fn:add-trailing-slash(translate($path-to-view-svg, '\', '/'))"/>
	
	<xsl:variable name="ext-xml" select="if (xs:boolean($static)) then '.xml' else ''" as="xs:string?"/>
	<xsl:variable name="ext-html" select="if (xs:boolean($static)) then '.html' else ''" as="xs:string?"/>
	<xsl:variable name="index" select="if (xs:boolean($static)) then 'index' else ''" as="xs:string?"/>
	
	
	<xsl:template match="/app">
		<xsl:apply-templates select="view/data/person/related" mode="network-graph" />
	</xsl:template>
	
	<xsl:template match="related" mode="network-graph" priority="10">
		<xsl:variable name="node-data" as="element()*">
			<xsl:variable name="may-contain-duplicates" as="element()*">
				<xsl:apply-templates select="self::*" mode="network-graph.data.node">
					<xsl:with-param name="subject" select="parent::person" as="element()" tunnel="yes" />
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:for-each-group select="$may-contain-duplicates" group-by="property[@label = 'id']">
				<xsl:sort select="property[@label = 'level']" data-type="number" order="ascending" />
				<xsl:for-each select="current-group()">
					<xsl:sort select="property[@label = 'level']" data-type="number" order="ascending" />
					<xsl:sort select="property[@label = 'size']" data-type="number" order="descending" />
					<xsl:if test="position() = 1">
						<xsl:sequence select="current()" />
					</xsl:if>
				</xsl:for-each>	
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:variable name="edge-data" as="element()*">
			<xsl:variable name="may-contain-duplicates" as="element()*">
				<xsl:apply-templates select="self::*" mode="network-graph.data.edge">
					<xsl:with-param name="subject" select="parent::person" as="element()" tunnel="yes" />
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:for-each-group select="$may-contain-duplicates" group-by="concat(property[@label = 'from'], property[@label = 'to'])">
				<xsl:sort select="property[@label = 'length']" data-type="number" order="descending" />
				<xsl:sequence select="current-group()[1]" />	
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:variable name="stored-layout" select="if (parent::person[@x][@y]) then true() else false()" as="xs:boolean" />
		
		
		<xsl:apply-templates select="self::*" mode="network-graph.serialize.dot">
			<xsl:with-param name="graph-variable-name" select="'networkData'" as="xs:string" tunnel="yes" />
			<xsl:with-param name="node-data" select="$node-data" as="element()*" tunnel="yes" />
			<xsl:with-param name="edge-data" select="$edge-data" as="element()*" tunnel="yes" />
		</xsl:apply-templates>
		
	</xsl:template>
	

	<xsl:template match="related" mode="network-graph.data.node">
		<xsl:param name="subject" as="element()" tunnel="yes" />
		
		<!-- Subject's birth and parents -->
		<xsl:apply-templates select="event[@type = 'birth'][person/@ref = $subject/@id]" mode="#current">
			<xsl:with-param name="level" select="1" as="xs:integer" />
		</xsl:apply-templates>
			
		<!-- Subject's children and co-parents -->
		<xsl:for-each-group select="event[@type = 'birth'][parent/@ref = $subject/@id]" group-by="parent[@ref != $subject/@id][1]/@ref">
			<xsl:sort select="date/@year" data-type="number" order="ascending" />
			<xsl:sort select="date/@month" data-type="number" order="ascending" />
			<xsl:sort select="date/@day" data-type="number" order="ascending" />
			<xsl:sort select="person/key('person', @ref)/@year" data-type="number" order="ascending" />
			<xsl:apply-templates select="current-group()" mode="#current">
				<xsl:sort select="date/@year" data-type="number" order="ascending" />
				<xsl:sort select="date/@month" data-type="number" order="ascending" />
				<xsl:sort select="date/@day" data-type="number" order="ascending" />
				<xsl:sort select="person/key('person', @ref)/@year" data-type="number" order="ascending" />
				<xsl:with-param name="level" select="2" as="xs:integer" />
			</xsl:apply-templates>
		</xsl:for-each-group>
		
	</xsl:template>
	
	<xsl:template match="related" mode="network-graph.data.edge">
		<xsl:param name="subject" as="element()" tunnel="yes" />
		
		<!-- Parents: distinct parent groups -->
		<xsl:for-each-group select="fn:get-birth-events($subject)" group-by="fn:get-inferred-relationship-id(current())">
			<xsl:sort select="date/@year" data-type="number" order="ascending" />
			<xsl:sort select="date/@month" data-type="number" order="ascending" />
			<xsl:sort select="date/@day" data-type="number" order="ascending" />
			
			<xsl:variable name="node-id" select="current-grouping-key()" as="xs:string" />
			
			<!-- Parents in group: edge from parent to relationship -->
			<xsl:apply-templates select="current-group()[1]/parent" mode="#current">
				<xsl:sort select="parent/key('person', @ref)/@year" data-type="number" order="ascending" />
				<xsl:with-param name="node-id" select="$node-id" as="xs:string" />
			</xsl:apply-templates>
			
			<!-- Subject: edge from subject (as child) to relationship -->
			<xsl:apply-templates select="current-group()[1]/person" mode="#current">
				<xsl:with-param name="node-id" select="$node-id" as="xs:string" />
			</xsl:apply-templates>
			
		</xsl:for-each-group>
		
		
		<!-- Co-parents: distinct co-parent groups -->
		<xsl:for-each-group select="fn:get-birth-events($subject, 'parent')" group-by="fn:get-inferred-relationship-id(current())">
			<xsl:sort select="date/@year" data-type="number" order="ascending" />
			<xsl:sort select="date/@month" data-type="number" order="ascending" />
			<xsl:sort select="date/@day" data-type="number" order="ascending" />
			
			<xsl:variable name="node-id" select="current-grouping-key()" as="xs:string" />

			<!-- Parents in group: edge from parent to relationship -->
			<xsl:apply-templates select="current-group()[1]/parent" mode="#current">
				<xsl:sort select="parent/key('person', @ref)/@year" data-type="number" order="ascending" />
				<xsl:with-param name="node-id" select="$node-id" as="xs:string" />
			</xsl:apply-templates>
			
			<!-- Children: edge from subject's children to relationship -->
			<xsl:apply-templates select="current-group()/person" mode="#current">				
				<xsl:sort select="person/key('person', @ref)/@year" data-type="number" order="ascending" />
				<xsl:with-param name="node-id" select="$node-id" as="xs:string" />
			</xsl:apply-templates>
			
		</xsl:for-each-group>
		
	</xsl:template>

	
	<xsl:template match="event[@type = 'birth']/person" mode="network-graph.data.edge">
		<xsl:param name="node-id" select="parent::event/@id" as="xs:string" />
		
		<!-- Subject to relationship node -->
		<xsl:call-template name="network-graph.edge">
			<xsl:with-param name="to" select="@ref" as="xs:string" />
			<xsl:with-param name="from" select="$node-id" as="xs:string" />
		</xsl:call-template>
		
	</xsl:template>
	
	
	<xsl:template match="event[@type = 'birth']/parent" mode="network-graph.data.edge">
		<xsl:param name="node-id" select="parent::event/@id" as="xs:string" />
		
		<!-- Parent to relationship node -->
		<xsl:call-template name="network-graph.edge">
			<xsl:with-param name="to" select="if (position() = 1) then $node-id else @ref" as="xs:string" />
			<xsl:with-param name="from" select="if (position() = 1) then @ref else $node-id" as="xs:string" />
			<xsl:with-param name="length" select="count(fn:get-name(self::*)) + 300" as="xs:integer" />
		</xsl:call-template>
		
	</xsl:template>


	<doc:doc>
		<doc:title>Create Nodes: Birth</doc:title>
	</doc:doc>
	<xsl:template match="event[@type = 'birth']" mode="network-graph.data.node">
		<xsl:param name="level" as="xs:integer" />
		
		<!-- Subject -->
		<xsl:apply-templates select="person/key('person', @ref)" mode="#current">
			<xsl:with-param name="level" select="$level + 1" as="xs:integer" tunnel="yes" />
		</xsl:apply-templates>
		
		<!-- Parents -->
		<xsl:apply-templates select="parent[1]/key('person', @ref)" mode="#current">
			<xsl:sort select="@year" data-type="number" order="ascending" />
			<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
		</xsl:apply-templates>
		
		<xsl:variable name="parental-relationship-inferred-id" select="fn:get-inferred-relationship-id(current())" as="xs:string" />
		
		<!-- Parental Relationship -->
		<xsl:call-template name="network-graph.node">
			<xsl:with-param name="id" select="$parental-relationship-inferred-id" as="xs:string" />
			<xsl:with-param name="label" as="node()*">
				<xsl:variable name="relationship-events" as="element()*">
					<xsl:for-each select="ancestor::related[1]/event[@type = ('marriage', 'divorce')]">
						<xsl:variable name="candidate-relationship-inferred-id" select="fn:get-inferred-relationship-id(current())" as="xs:string" />
						<xsl:if test="$candidate-relationship-inferred-id = $parental-relationship-inferred-id">
							<xsl:sequence select="current()" />
						</xsl:if>
					</xsl:for-each>
				</xsl:variable> 
				<xsl:for-each-group select="$relationship-events[@type = ('marriage', 'divorce')]" group-starting-with="@type[. = 'marriage']">
					<xsl:sort select="date/@year" data-type="number" order="ascending" />
					<xsl:sort select="date/@month" data-type="number" order="ascending" />
					<xsl:sort select="date/@day" data-type="number" order="ascending" />
					
					<xsl:for-each-group select="current-group()" group-ending-with="@type[. = 'divorce']">
						<xsl:for-each select="current-group()">
							<font face="DejaVu Sans"><xsl:choose>
									<xsl:when test="@type = 'marriage'"><xsl:text>⚭</xsl:text></xsl:when>
									<xsl:when test="@type = 'divorce'"><xsl:text>⚮</xsl:text></xsl:when>
							</xsl:choose></font>
							<xsl:if test="count($relationship-events) = 1"><br /></xsl:if>
							<xsl:if test="date/@year != ''">
								<xsl:if test="count($relationship-events) &gt; 1"><xsl:value-of select="codepoints-to-string(8202)" /></xsl:if>
								<i><xsl:value-of select="date/@year" /></i>
							</xsl:if>
							<xsl:if test="@type = 'marriage' and position() != last()"><xsl:text> – </xsl:text></xsl:if>
						</xsl:for-each>
						<xsl:if test="position() != last()">,<br /></xsl:if>
					</xsl:for-each-group>
				
				</xsl:for-each-group>
			</xsl:with-param>
			<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
		</xsl:call-template>
		
		<!-- Parents -->
		<xsl:apply-templates select="parent[position() > 1]/key('person', @ref)" mode="#current">
			<xsl:sort select="@year" data-type="number" order="ascending" />
			<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	
	<xsl:template match="person[@id]" mode="network-graph.data.node">
		<xsl:call-template name="network-graph.node">
			<xsl:with-param name="id" select="@id" as="xs:string" />
			<xsl:with-param name="label" as="node()*">
				<xsl:value-of select="normalize-space(fn:get-name(self::*))" />
				<xsl:for-each select="fn:get-birth-events(self::*)[date/@year][1]">
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
					<font face="DejaVu Sans">–✝</font><i><xsl:value-of select="$end-date/date/@year" /></i>
				</xsl:if>
			</xsl:with-param>
			<xsl:with-param name="url" select="xs:anyURI(concat($normalised-path-to-view-html, 'person/', @id, '/'))" as="xs:anyURI" />
		</xsl:call-template>
	</xsl:template>
	

	<xsl:template name="network-graph.node">
		<xsl:param name="id" as="xs:string" />
		<xsl:param name="label" as="node()*" />
		<xsl:param name="level" as="xs:integer" tunnel="yes" />
		<xsl:param name="url" as="xs:anyURI?" />
 		
		<object type="node">
			<property label="id" data-type="xs:string"><xsl:value-of select="$id" /></property>
			<property label="label" data-type="label"><xsl:copy-of select="$label" /></property>
			<property label="size" data-type="xs:integer"><xsl:value-of select="10" /></property>
			<property label="mass" data-type="xs:integer"><xsl:value-of select="10" /></property>
			<property label="level" data-type="xs:integer"><xsl:value-of select="$level" /></property>
			<xsl:if test="$url != ''">
				<property label="url" data-type="xs:anyURI"><xsl:value-of select="$url" /></property>
			</xsl:if>
			<xsl:if test="@x or @y">
				<property label="fixed" data-type="boolean">true</property>
				<xsl:if test="@x">
					<property label="x" data-type="xs:integer">
						<xsl:value-of select="@x"/>
					</property>
				</xsl:if>
				<xsl:if test="@y">
					<property label="y" data-type="xs:integer">
						<xsl:value-of select="@y"/>
					</property>
				</xsl:if>
			</xsl:if>
		</object>
		
	</xsl:template>	
	
	
	<xsl:template name="network-graph.edge">
		<xsl:param name="from" as="xs:string" />
		<xsl:param name="to" as="xs:string" />
		<xsl:param name="length" select="300" as="xs:integer" />
		
		<object type="edge">
			<property label="from" data-type="xs:string"><xsl:value-of select="$from" /></property>
			<property label="to" data-type="xs:string"><xsl:value-of select="$to" /></property>
			<property label="color" data-type="xs:string">#000000</property>
			<property label="length" data-type="xs:integer"><xsl:value-of select="$length" /></property>
		</object>
	</xsl:template>
	

</xsl:stylesheet>
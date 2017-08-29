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
	<xsl:import href="serialise.vis.xsl" />
	
	<xsl:param name="path-to-js" select="'../../js/'" as="xs:string"/>
	<xsl:param name="path-to-css" select="'../../css/'" as="xs:string"/>
	<xsl:param name="path-to-view-xml" select="'../xml'" as="xs:string"/>
	<xsl:param name="path-to-view-html" select="'../html'" as="xs:string"/>
	<xsl:param name="path-to-view-js" select="'../js'" as="xs:string"/>
	<xsl:param name="path-to-images" select="'../../images'" as="xs:string"/>
	<xsl:param name="static" select="'false'" as="xs:string"/>
	
	<xsl:strip-space elements="*"/>
	
	<xsl:output method="xml" encoding="utf-8" media-type="application/javascript" indent="no" omit-xml-declaration="yes" />
	
	<xsl:variable name="normalised-path-to-js" select="fn:add-trailing-slash(translate($path-to-js, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-css" select="fn:add-trailing-slash(translate($path-to-css, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-images" select="fn:add-trailing-slash(translate($path-to-images, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-view-xml" select="fn:add-trailing-slash(translate($path-to-view-xml, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-view-html" select="fn:add-trailing-slash(translate($path-to-view-html, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-view-js" select="fn:add-trailing-slash(translate($path-to-view-js, '\', '/'))"/>
	
	<xsl:variable name="ext-xml" select="if (xs:boolean($static)) then '.xml' else ''" as="xs:string?"/>
	<xsl:variable name="ext-html" select="if (xs:boolean($static)) then '.html' else ''" as="xs:string?"/>
	<xsl:variable name="index" select="if (xs:boolean($static)) then 'index' else ''" as="xs:string?"/>
	
	
	<xsl:template match="/app">
		<xsl:apply-templates select="view/data/person/related" mode="network-graph" />
	</xsl:template>
	
	<xsl:template match="related" mode="network-graph" priority="10">
		<xsl:variable name="people-node-data" as="element()*">
			<xsl:variable name="may-contain-duplicates" as="element()*">
				<xsl:apply-templates select="self::*" mode="network-graph.data.node">
					<xsl:with-param name="subject" select="parent::person" as="element()" tunnel="yes" />
				</xsl:apply-templates>
			</xsl:variable>
			<xsl:for-each-group select="$may-contain-duplicates" group-by="property[@label = 'id']">
				<xsl:sort select="property[@label = 'size']" data-type="number" order="descending" />
				<xsl:sequence select="current-group()[1]" />	
			</xsl:for-each-group>
		</xsl:variable>
		<xsl:variable name="people-edge-data" as="element()*">
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
		
		<xsl:apply-templates select="self::*" mode="network-graph.serialize.vis">
			<xsl:with-param name="node-data-variable-name" select="'peopleNodeData'" as="xs:string" />
			<xsl:with-param name="edge-data-variable-name" select="'peopleEdgeData'" as="xs:string" />
			<xsl:with-param name="node-data" select="$people-node-data" as="element()*" />
			<xsl:with-param name="edge-data" select="$people-edge-data" as="element()*" />
			<xsl:with-param name="stored-layout" select="$stored-layout" as="xs:boolean" />
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
			<xsl:apply-templates select="current-group()" mode="#current">
				<xsl:with-param name="level" select="2" as="xs:integer" />
			</xsl:apply-templates>
		</xsl:for-each-group>
		
	</xsl:template>
	
	<xsl:template match="related" mode="network-graph.data.edge">
		<xsl:param name="subject" as="element()" tunnel="yes" />
		
		
		<!-- Subject's birth and parents -->
		<xsl:for-each-group select="event[@type = 'birth'][person/@ref = $subject/@id]" group-by="count(parent)">
			<xsl:variable name="node-id" select="current-group()[1]/string-join(parent/@ref, '')" as="xs:string" />
			
			<xsl:for-each select="current-group()[1]/parent">
				<xsl:apply-templates select="self::parent" mode="#current">
					<xsl:with-param name="node-id" select="$node-id" as="xs:string" />
				</xsl:apply-templates>
			</xsl:for-each>
			
			<xsl:apply-templates select="current-group()" mode="#current">
				<xsl:with-param name="node-id" select="$node-id" as="xs:string" />
			</xsl:apply-templates>
			
		</xsl:for-each-group>
		
		
		<!-- Subject's children and co-parents -->
		<xsl:for-each-group select="event[@type = 'birth'][parent/@ref = $subject/@id]" group-by="parent[@ref != $subject/@id][1]/@ref">
			<xsl:variable name="node-id" select="current-group()[1]/string-join(parent/@ref, '')" as="xs:string" />
			
			<xsl:for-each select="current-group()[1]/parent">
				<xsl:apply-templates select="self::parent" mode="#current">
					<xsl:with-param name="node-id" select="$node-id" as="xs:string" />
				</xsl:apply-templates>
			</xsl:for-each>
			
			<xsl:apply-templates select="current-group()" mode="#current">
				<xsl:sort select="date/@year" data-type="number" order="ascending" />
				<xsl:sort select="date/@month" data-type="number" order="ascending" />
				<xsl:sort select="date/@day" data-type="number" order="ascending" />
				<xsl:sort select="person/key('person', @ref)/@year" data-type="number" order="ascending" />
				<xsl:with-param name="node-id" select="$node-id" as="xs:string" />
			</xsl:apply-templates>
			
		</xsl:for-each-group>
		
	</xsl:template>

	
	<xsl:template match="event[@type = 'birth']/person" mode="network-graph.data.edge">
		<xsl:param name="node-id" select="parent::event/@id" as="xs:string" />
		
		<!-- Subject to relationship node -->
		<xsl:call-template name="network-graph.edge">
			<xsl:with-param name="from" select="@ref" as="xs:string" />
			<xsl:with-param name="to" select="$node-id" as="xs:string" />
		</xsl:call-template>
		
	</xsl:template>
	
	
	<xsl:template match="event[@type = 'birth']/parent" mode="network-graph.data.edge">
		<xsl:param name="node-id" select="parent::event/@id" as="xs:string" />
		
		<!-- Parent to relationship node -->
		<xsl:call-template name="network-graph.edge">
			<xsl:with-param name="from" select="@ref" as="xs:string" />
			<xsl:with-param name="to" select="$node-id" as="xs:string" />
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
			<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
		</xsl:apply-templates>
		
		<!-- Parental Relationship -->
		<xsl:call-template name="network-graph.node">
			<xsl:with-param name="id" select="string-join(parent/@ref, '')" as="xs:string" />
			<xsl:with-param name="label" as="node()*">co-parents</xsl:with-param>
			<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
		</xsl:call-template>
		
		<!-- Parents -->
		<xsl:apply-templates select="parent[position() > 1]/key('person', @ref)" mode="#current">
			<xsl:with-param name="level" select="$level" as="xs:integer" tunnel="yes" />
		</xsl:apply-templates>
		
	</xsl:template>
	
	
	<xsl:template match="person[@id]" mode="network-graph.data.node">
		<xsl:call-template name="network-graph.node">
			<xsl:with-param name="id" select="@id" as="xs:string" />
			<xsl:with-param name="label" as="node()*">
				<xsl:value-of select="normalize-space(fn:get-name(self::*))" />
				<xsl:for-each select="/app/view/data/person/related/event[@type = ('birth', 'christening')][person/@ref = current()/@id][date/@year][1]">
					<xsl:sort select="date/@year" data-type="number" order="ascending" />
					<xsl:sort select="date/@month" data-type="number" order="ascending" />
					<xsl:sort select="date/@day" data-type="number" order="ascending" />
					<xsl:text>, </xsl:text><br /><i><xsl:choose><xsl:when test="@type = 'birth'">b.</xsl:when><xsl:when test="@type = 'christening'">c.</xsl:when><xsl:otherwise>~</xsl:otherwise></xsl:choose><xsl:value-of select="date/@year" /></i>
				</xsl:for-each>
			</xsl:with-param>
			<xsl:with-param name="icon" as="xs:string?">
				<xsl:variable name="glyph" as="xs:string*">
					<xsl:apply-templates select="fn:get-default-persona(self::*)/gender" mode="glyph" />
				</xsl:variable>
				<xsl:value-of select="translate(normalize-space(string-join($glyph, '')), ' ', '')"/>
			</xsl:with-param>
		</xsl:call-template>
	</xsl:template>
	

	<xsl:template name="network-graph.node">
		<xsl:param name="id" as="xs:string" />
		<xsl:param name="label" as="node()*" />
		<xsl:param name="level" as="xs:integer" tunnel="yes" />
		<xsl:param name="icon" as="xs:string?" />
		
		<object>
			<property label="id" data-type="xs:string"><xsl:value-of select="$id" /></property>
			<property label="label" data-type="label"><xsl:copy-of select="$label" /></property>
			<property label="size" data-type="xs:integer"><xsl:value-of select="10" /></property>
			<property label="mass" data-type="xs:integer"><xsl:value-of select="10" /></property>
			<property label="level" data-type="xs:integer"><xsl:value-of select="$level" /></property>
			<xsl:if test="$icon != ''">
				<property label="shape" data-type="xs:string">icon</property>
				<property label="icon" data-type="object">
					<property label="code" data-type="xs:string"><xsl:value-of select="$icon" /></property>
				</property>
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
		
		<object>
			<property label="from" data-type="xs:string"><xsl:value-of select="$from" /></property>
			<property label="to" data-type="xs:string"><xsl:value-of select="$to" /></property>
			<property label="color" data-type="xs:string">#000000</property>
			<property label="length" data-type="xs:integer"><xsl:value-of select="$length" /></property>
		</object>
	</xsl:template>
	

</xsl:stylesheet>
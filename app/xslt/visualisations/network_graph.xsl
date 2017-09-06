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
	<xsl:import href="serialise.vis.xsl" />
	
	<xsl:param name="static" select="'false'" as="xs:string"/>
	<xsl:param name="serialise" select="'none'" as="xs:string" />
	<xsl:param name="graph-direction" select="'TD'" as="xs:string" />
	
	<xsl:param name="path-to-js" select="'../../js/'" as="xs:string"/>
	<xsl:param name="path-to-css" select="'../../css/'" as="xs:string"/>
	<xsl:param name="path-to-view-xml" select="'../xml'" as="xs:string"/>
	<xsl:param name="path-to-view-html" select="'../html'" as="xs:string"/>
	<xsl:param name="path-to-view-svg" select="'../svg'" as="xs:string"/>
	<xsl:param name="path-to-images" select="'../../images'" as="xs:string"/>
	
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
	
	<xsl:output method="xml" encoding="UTF-8" media-type="text/xml" indent="yes" omit-xml-declaration="yes" />
	
	
	<xsl:template name="network-graph">
		<xsl:param name="network-name" select="'networkData'" as="xs:string" />
		<xsl:param name="node-data" as="element()*" />
		<xsl:param name="edge-data" as="element()*" />
		<xsl:param name="stored-layout" select="false()" as="xs:boolean" />
		
		<network name="{$network-name}" stored-layout="{$stored-layout}">
			<config>
				<settings scope="global">
					<xsl:text>graph [fontname = "IM FELL DW Pica"];&#10;</xsl:text>
					<!-- Global node settings -->
					<xsl:text>node [fontname = "IM FELL DW Pica", shape = none];&#10;</xsl:text>
					<!-- Global edge settings -->
					<xsl:text>edge [fontname = "IM FELL DW Pica"];&#10;</xsl:text>
				</settings>
				<rank direction="{$graph-direction}" />
			</config>
			<nodes>
				<xsl:copy-of select="$node-data" />
			</nodes>
			<edges>
				<xsl:copy-of select="$edge-data" />
			</edges>
		</network>
		
	</xsl:template>
	
	
	
	<xsl:template match="network" mode="network-graph.serialise">
		
		<xsl:choose>
			<xsl:when test="$serialise = 'dot'">
				<xsl:result-document format="dot">
					<xsl:apply-templates select="self::*" mode="network-graph.serialize.dot" />					
				</xsl:result-document>
			</xsl:when>
			<xsl:when test="$serialise = 'vis'">
				<xsl:result-document format="vis">
					<xsl:apply-templates select="self::*" mode="network-graph.serialize.vis" />
				</xsl:result-document>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy-of select="self::*" />					
			</xsl:otherwise>
		</xsl:choose>
		
	</xsl:template>
	
	
	<xsl:template match="network" mode="network-graph.serialize.dot network-graph.serialize.viz" priority="100">
		<xsl:choose>
			<xsl:when test="$static = 'true'">
				<result>
					<xsl:next-match />
				</result>
			</xsl:when>
			<xsl:otherwise>
				<xsl:next-match />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	

	<xsl:template name="network-graph.node">
		<xsl:param name="id" as="xs:string" />
		<xsl:param name="label" as="node()*" />
		<xsl:param name="level" as="xs:integer?" tunnel="yes" />
		<xsl:param name="url" as="xs:anyURI?" />
		<xsl:param name="size" as="xs:integer?" />
		<xsl:param name="mass" as="xs:integer?" />
 		
		<object type="node">
			<property label="id" data-type="xs:string"><xsl:value-of select="$id" /></property>
			<property label="label" data-type="label"><xsl:copy-of select="$label" /></property>
			<xsl:if test="$size">
				<property label="size" data-type="xs:integer"><xsl:value-of select="10" /></property>
			</xsl:if>
			<xsl:if test="$mass">
				<property label="mass" data-type="xs:integer"><xsl:value-of select="10" /></property>
			</xsl:if>
			<xsl:if test="$level">
				<property label="level" data-type="xs:integer"><xsl:value-of select="$level" /></property>
			</xsl:if>
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
		<xsl:param name="length" as="xs:integer?" />
		<xsl:param name="color" as="xs:string?" />
		
		<object type="edge">
			<property label="from" data-type="xs:string"><xsl:value-of select="$from" /></property>
			<property label="to" data-type="xs:string"><xsl:value-of select="$to" /></property>
			<xsl:if test="$color != ''">
				<property label="color" data-type="xs:string">#000000</property>
			</xsl:if>
			<xsl:if test="$length">
				<property label="length" data-type="xs:integer"><xsl:value-of select="$length" /></property>
			</xsl:if>
		</object>
	</xsl:template>
	

</xsl:stylesheet>
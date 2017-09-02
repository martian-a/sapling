<xsl:stylesheet 
    xmlns:gw="http://ns.greenwood.thecodeyard.co.uk/xslt/functions" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="#all"
    version="2.0" > 
	
	
	<xsl:template match="related" mode="network-graph.serialize.dot" priority="100">
		<xsl:result-document method="text" encoding="utf-8" media-type="application/javascript" indent="no" omit-xml-declaration="yes">
	        <xsl:next-match />
		</xsl:result-document>
	</xsl:template>
	
	
	<xsl:template match="*" mode="network-graph.serialize.vis">
		<xsl:param name="node-data-variable-name" select="'nodeData'" as="xs:string" tunnel="yes" />
		<xsl:param name="edge-data-variable-name" select="'edgeData'" as="xs:string" tunnel="yes" />
		<xsl:param name="node-data" as="element()*" tunnel="yes" />
		<xsl:param name="edge-data" as="element()*" tunnel="yes" />
		<xsl:param name="stored-layout" select="false()" as="xs:boolean" tunnel="yes" />
				
		<!-- Create an array representing the nodes in the network (family tree) -->
		<xsl:text>var </xsl:text><xsl:value-of select="$node-data-variable-name" /><xsl:text> = [</xsl:text>
		<xsl:apply-templates select="$node-data" mode="serialize.vis" />	
		<xsl:text>];</xsl:text>
		
		<xsl:text>&#10;&#10;</xsl:text>
		
		<!-- Create an array representing the edges in the network (family tree) -->
		<xsl:text>var </xsl:text><xsl:value-of select="$edge-data-variable-name" /><xsl:text> = [</xsl:text>
		<xsl:apply-templates select="$edge-data" mode="serialize.vis" />
		<xsl:text>];</xsl:text>
		
		<xsl:text>&#10;&#10;</xsl:text>
		
		<xsl:text>var storedLayout = </xsl:text><xsl:value-of select="$stored-layout"/><xsl:text>;</xsl:text>
	</xsl:template>
	
  
    <xsl:template match="object" mode="serialize.vis">
        <xsl:text>{&#10;</xsl:text>
        <xsl:apply-templates mode="#current" />
        <xsl:text>}</xsl:text>
        <xsl:if test="position() != last()">,</xsl:if>
    </xsl:template>
    
    <xsl:template match="property" mode="serialize.vis" priority="10">
        <xsl:value-of select="concat(@label, ': ')" />
        <xsl:next-match />
        <xsl:if test="position() != last()">,</xsl:if>
        <xsl:text>&#10;</xsl:text>
    </xsl:template>
    
    <xsl:template match="property[@data-type = 'object']" mode="serialize.vis" priority="5">
		<xsl:text>{
</xsl:text>
		<xsl:apply-templates mode="#current"/>
		<xsl:text>}</xsl:text>
	</xsl:template>
    
	<xsl:template match="property[@data-type = 'xs:string'] | property[@data-type = 'boolean'] | property[@data-type = 'xs:integer'][starts-with(normalize-space(.), '-')] | property[@data-type = 'label']" mode="serialize.vis" priority="5">
        <xsl:text>'</xsl:text><xsl:next-match /><xsl:text>'</xsl:text>
    </xsl:template>
	
	<xsl:template match="property[@data-type = 'label']" mode="serialize.vis">
		<xsl:apply-templates select="node()" mode="serialize.vis.label" />
	</xsl:template>
	
	<xsl:template match="br" mode="serialize.vis.label" />
	
	<xsl:template match="element()" mode="serialize.vis.label">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" mode="#current" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="text()" mode="serialize.vis.label">
		<xsl:copy />
	</xsl:template>
	
	
    
    <xsl:template match="property" mode="serialize.vis">
        <xsl:value-of select="." />
    </xsl:template>
    
</xsl:stylesheet>
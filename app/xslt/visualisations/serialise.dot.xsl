<xsl:stylesheet 
    xmlns:gw="http://ns.greenwood.thecodeyard.co.uk/xslt/functions" 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema" 
    exclude-result-prefixes="#all"
    version="2.0" > 
	
	<xsl:output name="dot" method="text" encoding="UTF-8" media-type="text/vnd.graphviz" indent="no" omit-xml-declaration="yes" />
	
	<xsl:template match="network[not(nodes)]" mode="network-graph.serialize.dot" />
	
	<xsl:template match="network[nodes]" mode="network-graph.serialize.dot">
		<xsl:param name="graph-variable-name" select="'network'" as="xs:string" tunnel="yes" />
		<xsl:param name="node-data" as="element()*" tunnel="yes" />
		<xsl:param name="edge-data" as="element()*" tunnel="yes" />
		
		<!-- Create an array representing the nodes in the network (family tree) -->
		<xsl:text>graph </xsl:text><xsl:value-of select="@name" /><xsl:text> {&#10;</xsl:text>
		
		<xsl:text>&#10;</xsl:text>
		
		<!-- Global graph settings -->
		<xsl:value-of select="config/settings[@scope = 'global']" />
		
		<xsl:text>&#10;&#10;</xsl:text>
		
		<xsl:apply-templates select="nodes" mode="serialize.dot" />
		
		<xsl:text>&#10;&#10;</xsl:text>
		
		<xsl:apply-templates select="edges" mode="serialize.dot" />
		
		<xsl:text>&#10;&#10;</xsl:text>
		
		<xsl:apply-templates select="nodes[object/property/@label = 'level']" mode="serialize.dot.rank" />
		
		<xsl:text>&#10;</xsl:text>
		
		<xsl:text>}</xsl:text>
			
	</xsl:template>
	
	<xsl:template match="nodes" mode="serialize.dot.rank">
		<xsl:param name="node-data" as="element()*" />
		
		<xsl:text>rankdir = </xsl:text><xsl:value-of select="ancestor::network/config/rank/@direction" /><xsl:text>;&#10;</xsl:text>
		<xsl:for-each-group select="object" group-by="property[@label = 'level']">
			<xsl:sort select="current-grouping-key()" data-type="number" order="ascending" />
			<xsl:text>{rank = same; </xsl:text>
			<xsl:for-each select="current-group()">
				<xsl:value-of select="property[@label = 'id']" /><xsl:text>; </xsl:text>
			</xsl:for-each>
			<xsl:text>}</xsl:text>
		</xsl:for-each-group>
		<xsl:text>&#10;</xsl:text>
		
	</xsl:template>
	
  
    <xsl:template match="object[@type = 'node']" mode="serialize.dot">
        <xsl:value-of select="property[@label = 'id']" />
    	<xsl:if test="property[@label = 'label']">
    		<xsl:text> [</xsl:text>
    			<xsl:for-each select="property[not(@label = ('id', 'level'))]">
    				<xsl:apply-templates select="self::property" mode="#current" />
    				<xsl:if test="position() != last()"><xsl:text>, </xsl:text></xsl:if>	
    			</xsl:for-each>
    		<xsl:text>]</xsl:text>
    	</xsl:if>
    	<xsl:text>;&#10;</xsl:text>
    </xsl:template>
    
    
	<xsl:template match="property[@data-type = 'label']" mode="serialize.dot">
		<xsl:text>label</xsl:text><xsl:text>=</xsl:text><xsl:value-of select="codepoints-to-string(60)" /><xsl:apply-templates select="node()" mode="serialize.dot.label" /><xsl:value-of select="codepoints-to-string(62)" />
	</xsl:template>
	
	<xsl:template match="property[starts-with(@data-type, 'xs:string')]" mode="serialize.dot">
		<xsl:value-of select="@label" /><xsl:text>="</xsl:text><xsl:value-of select="." /><xsl:text>"</xsl:text>
	</xsl:template>
	

	<!-- Empty html node (eg. br) -->
	<xsl:template match="element()[not(@*)][not(node())]" mode="serialize.dot.label">
		<xsl:value-of select="concat(codepoints-to-string(60), name(), ' /', codepoints-to-string(62))" />
	</xsl:template>
	
	<!-- Non-empty html node, without attributes (eg. i) -->
	<xsl:template match="element()[not(@*)][node()]" mode="serialize.dot.label" priority="10">
		<xsl:value-of select="concat(codepoints-to-string(60), name(), codepoints-to-string(62))" />
			<xsl:next-match />
		<xsl:value-of select="concat(codepoints-to-string(60), '/', name(), codepoints-to-string(62))" />
	</xsl:template>
	
	<!-- Non-empty html node, with attributes (eg. font) -->
	<xsl:template match="element()[@*][node()]" mode="serialize.dot.label" priority="10">
		<xsl:variable name="attributes" as="element()*">
			<xsl:for-each select="@*">
				<attribute>
					<name><xsl:value-of select="name()" /></name>
					<value><xsl:value-of select="." /></value>
				</attribute>
			</xsl:for-each>
		</xsl:variable>
		<xsl:value-of select="codepoints-to-string(60)" /><xsl:value-of select="name()" /><xsl:for-each select="$attributes"><xsl:text> </xsl:text><xsl:value-of select="concat(name, '=', codepoints-to-string(34), value, codepoints-to-string(34))" /></xsl:for-each><xsl:value-of select="codepoints-to-string(62)" />
		<xsl:next-match />
		<xsl:value-of select="concat(codepoints-to-string(60), '/', name(), codepoints-to-string(62))" />
	</xsl:template>
	
	<xsl:template match="element()[node()]" mode="serialize.dot.label">
		<xsl:apply-templates select="node()" mode="#current" />
	</xsl:template>

	<xsl:template match="@* | text()" mode="serialize.dot.label">
		<xsl:copy />
	</xsl:template>
	
	<xsl:template match="property[@label = 'url']" mode="serialize.dot">
		<xsl:text>URL="</xsl:text><xsl:value-of select="." /><xsl:text>", target="_parent"</xsl:text>
	</xsl:template>
    
    
	<xsl:template match="object[@type = 'edge']" mode="serialize.dot">
		<xsl:value-of select="property[@label = 'from']" /><xsl:text> -- </xsl:text><xsl:value-of select="property[@label = 'to']" />		
		<xsl:text>;&#10;</xsl:text>
	</xsl:template>
    
</xsl:stylesheet>
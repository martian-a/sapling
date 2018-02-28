<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#"
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all" 
	version="2.0">
	
	
	<xsl:template match="source/body-matter[body or extract]" priority="50">
		<div class="body-matter">
			<xsl:next-match />
		</div>
	</xsl:template>
	
	<xsl:template match="body[ancestor::body-matter/parent::source]">
		<div class="body {if (*[not(self::table)]) then 'multi-column' else ''} {@length}">
			<xsl:apply-templates mode="body" />
		</div>
	</xsl:template>
	
	
	<xsl:template match="*" mode="body">
		<xsl:copy>
			<xsl:apply-templates select="attribute(), node()" mode="#current" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="@*" mode="body">
		<xsl:copy>
			<xsl:value-of select="." />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="*[@ref][name() = ('person', 'location', 'source', 'organisation', 'name', 'event')]" mode="body">
		<xsl:apply-templates select="self::*" />
	</xsl:template>
	
	
	<xsl:template match="heading" mode="body">
		<h1>
			<xsl:apply-templates select="attribute(), node()" mode="#current" />
		</h1>
	</xsl:template>
	
	<xsl:template match="quote" mode="body">
		<blockquote class="quote"><xsl:apply-templates mode="#current" /></blockquote>
	</xsl:template>
	
	<xsl:template match="quote[ancestor::*[name() = ('p', 'li', 'td', 'th')]]" mode="body">
		<span class="quote"><xsl:value-of select="$ldquo" /><xsl:apply-templates select="node()" /><xsl:value-of select="$rdquo" /></span>
	</xsl:template>
	
	<xsl:template match="note[@ref]" mode="body">
		<span class="note-ref"><sup>
			<xsl:for-each select="key('note', @ref)">
				<a id="{@id}-ref" href="#{@id}"><xsl:value-of select="label" /></a>
			</xsl:for-each>
		</sup></span>
	</xsl:template>
	
	<xsl:template match="bold" mode="body">
		<em class="bold"><xsl:apply-templates mode="#current" /></em>
	</xsl:template>
	
	<xsl:template match="italic" mode="body">
		<em class="italic"><xsl:apply-templates mode="#current" /></em>
	</xsl:template>
	
</xsl:stylesheet>
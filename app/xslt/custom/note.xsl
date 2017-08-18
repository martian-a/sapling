<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<xsl:strip-space elements="note p"/>
	
	<xsl:template match="*[note]" mode="notes">
		<div class="notes">
			<h2>Notes</h2>
			<xsl:apply-templates select="note" />
		</div>
	</xsl:template>
	
	<xsl:template match="note">
		<div class="note">
			<xsl:apply-templates />
		</div>
	</xsl:template>
	
	<xsl:template match="note/*[not(@ref)]">
		<xsl:copy>
			<xsl:apply-templates select="attribute(), node()" />
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
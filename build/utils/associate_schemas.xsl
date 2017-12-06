<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	version="2.0">
		
	<xsl:output method="xml" />	
		
	<xsl:template match="document-node()">
		<xsl:result-document>
			<xsl:processing-instruction name="xml-model">href="http://ns.thecodeyard.co.uk/schema/sapling.rnc?v=3.0.0" type="application/relax-ng-compact-syntax"</xsl:processing-instruction>
			<xsl:processing-instruction name="xml-model">href="http://ns.thecodeyard.co.uk/schema/sapling.sch?v=3.0.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>
			<xsl:copy-of select="node()" />
		</xsl:result-document>
	</xsl:template>
	
</xsl:stylesheet>
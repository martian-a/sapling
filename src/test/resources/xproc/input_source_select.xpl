<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:k="http://schema.kaikoda.com/ns/xproc" name="input-source-select" type="k:input-source-select" version="1.0">
	
	<p:input port="source" sequence="false" primary="true" />
	
	<p:output port="result" sequence="false" primary="true" />
	
	<p:xslt version="1.0" name="transform">			
		
		<p:input port="source">
			<p:pipe  step="input-source-select" port="source" />
		</p:input>
	
		<p:input port="stylesheet">
			<p:inline>
				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
					xmlns:xs="http://www.w3.org/2001/XMLSchema"
					xmlns:fn="http://ns.kaikoda.com/xslt/functions"
					exclude-result-prefixes="xs fn"
					version="2.0">
					
					<xsl:template match="/">
						<xsl:apply-templates select="/sapling/person" />
					</xsl:template>
					
					<xsl:template match="person">
						<xsl:element name="{name()}" />
					</xsl:template>
					
				</xsl:stylesheet>
			</p:inline>
		</p:input>
		
		<p:input port="parameters">
			<p:empty />
		</p:input>						
		
	</p:xslt>
	
	<p:identity />
	
</p:declare-step>
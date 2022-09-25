<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:void="http://rdfs.org/ns/void#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
	<xsl:output encoding="UTF-8" indent="yes" method="xml" media-type="text/xml" omit-xml-declaration="no" />
    
	<xsl:param name="filename" select="tokenize(translate(document-uri(/), '\', '/'), '/')[last()]" as="xs:string" />
	
	<xsl:template match="/">
		<network with-node-for-parent-group="{$with-node-for-parent-group}">
			<xsl:copy-of select="data/void:dataset/@void:name, data/prov:document" />
			<xsl:apply-templates select="data" />
		</network>
	</xsl:template>
	
	<xsl:function name="fn:get-default-person-name" as="element()?">
		<xsl:param name="person" as="element()" />
		
		<xsl:sequence select="$person/persona[normalize-space(name) != ''][1]/name" />
	</xsl:function>
	
	
	<xsl:function name="fn:normalise-persona-name" as="xs:string?">
		<xsl:param name="name-wrapper" as="element()?" />
		
		<xsl:value-of select="$name-wrapper/normalize-space(string-join(*, ' '))" />
		
	</xsl:function>
	
    
</xsl:stylesheet>
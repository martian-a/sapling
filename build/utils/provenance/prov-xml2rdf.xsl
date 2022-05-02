<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="3.0">
  
    <xsl:template match="prov:document" mode="provenance-rdf" priority="10">
    	<xsl:param name="dataset-uri" as="xs:anyURI" tunnel="true" />
    	
		<xsl:next-match>
			<xsl:with-param name="local-name" select="'Entity'" as="xs:string" />
			<xsl:with-param name="uri" select="$dataset-uri" as="xs:anyURI" />
		</xsl:next-match>
    	<xsl:apply-templates select="descendant::*[@prov:id]" mode="provenance-rdf.classes" />
    	<xsl:for-each-group select="descendant::prov:location" group-by="text()">
    		<xsl:apply-templates select="current-group()[1]" mode="provenance-rdf.classes" />
    	</xsl:for-each-group>
    </xsl:template>	
	
	<xsl:template match="prov:*[@prov:id][local-name() = ('entity', 'activity', 'agent', 'plan')] | prov:location" mode="provenance-rdf.classes" priority="10">		
		<xsl:next-match>
			<xsl:with-param name="local-name" select="fn:lower-case-to-title-case(local-name())" as="xs:string" />
		</xsl:next-match>		
	</xsl:template>
	
	
	<xsl:template match="prov:document | prov:*[@prov:id][local-name() = ('entity', 'activity', 'agent', 'plan')] | prov:location" mode="provenance-rdf provenance-rdf.classes">
		<xsl:param name="local-name" as="xs:string" />
		<xsl:param name="uri" select="if (@prov:id) then @prov:id else text()" as="xs:string" />
		
		<xsl:element name="prov:{$local-name}">
			<xsl:attribute name="rdf:about" select="$uri" />
			<xsl:apply-templates select="*[not(@prov:id)]/prov:*[@prov:ref]" mode="provenance-rdf.properties" />
			<xsl:apply-templates select="*[not(@prov:id)][not(*)]" mode="provenance-rdf.properties" />		
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="prov:plan[@prov:ref]" mode="provenance-rdf.properties" priority="1">
		<prov:hadPlan>
			<xsl:apply-templates select="@prov:ref" mode="#current" />	
		</prov:hadPlan>
	</xsl:template>
	
	<xsl:template match="prov:*[@prov:ref]" mode="provenance-rdf.properties">
		<xsl:element name="{parent::*/name()}">
			<xsl:apply-templates select="@prov:ref" mode="#current" />	
		</xsl:element>
	</xsl:template>	
		
	<xsl:template match="prov:location" mode="provenance-rdf.properties">
		<prov:atLocation rdf:resource="{.}" />
	</xsl:template>
	
	<xsl:template match="@prov:ref" mode="provenance-rdf.properties">
		<xsl:attribute name="rdf:resource" select="." />
	</xsl:template>	

	<xsl:template match="prov:startTime" mode="provenance-rdf.properties" priority="10">
		<prov:startedAtTime><xsl:next-match /></prov:startedAtTime>
	</xsl:template>
	
	<xsl:template match="prov:endTime" mode="provenance-rdf.properties" priority="10">
		<prov:endedAtTime><xsl:next-match /></prov:endedAtTime>
	</xsl:template>
	
	<xsl:template match="prov:startTime | prov:endTime" mode="provenance-rdf.properties">
		<xsl:attribute name="rdf:datatype">http://www.w3.org/2001/XMLSchema#dateTime</xsl:attribute>
		<xsl:value-of select="." />
	</xsl:template>
		  
	<xsl:function name="fn:lower-case-to-title-case" as="xs:string?">
		<xsl:param name="lower-case-string" as="xs:string?" />
		
		<xsl:sequence select="concat(upper-case(substring($lower-case-string, 1, 1)), substring($lower-case-string, 2))" />
	</xsl:function>			
		  
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="3.0">
	
	<xsl:param name="document-uri" select="document-uri(/)" as="xs:string" />
	
	<xsl:import href="../../utils/identity.xsl" />
	
	<xsl:output indent="yes" />	
	
	<xsl:template match="/*">
		<xsl:copy>
			<xsl:apply-templates select="ancestor::document-node()" mode="provenance-xml" />
			<xsl:apply-templates />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="prov:document" />
	<xsl:template match="prov:document/@*" />
	
 	
	<xsl:template match="document-node()" mode="provenance-xml">
		<xsl:param name="generating-agent" select="/*/@pipeline-product-vendor-uri" as="xs:anyURI" />
		<xsl:param name="transformation-id" select="concat('REPLACE-', generate-id())" as="xs:string" />
		<xsl:param name="transformation-start-time" select="xs:dateTime((/*/@pipeline-start-time, current-dateTime())[1])" as="xs:dateTime" />
		<xsl:param name="transformation-end-time" select="xs:dateTime((/*/@pipeline-end-time, current-dateTime())[1])" as="xs:dateTime" />
		<xsl:param name="generated-by-user" select="/*/@generated-by-user" as="xs:string?" />
		<xsl:param name="generated-by-pipeline" select="/*/@generated-by-pipeline" as="xs:string?" />
				
		<prov:document>
			<xsl:attribute name="xml:id">
				<xsl:choose>
					<xsl:when test="/*/@xml:id"><xsl:value-of select="/*/@xml:id" /></xsl:when>
					<xsl:when test="/*/@uuid">SAP-<xsl:value-of select="/*/@uuid" /></xsl:when>				
				</xsl:choose>
			</xsl:attribute>
			
			<!-- result document -->
			<prov:wasGeneratedBy>
				<prov:entity prov:ref="{$generating-agent}" />
				<prov:activity prov:ref="{$transformation-id}" />
			</prov:wasGeneratedBy>    				   
			
			<prov:entity prov:id="{$generating-agent}" />
			
			<prov:activity prov:id="{$transformation-id}">
				<prov:startTime><xsl:value-of select="$transformation-start-time" /></prov:startTime>
				<prov:endTime><xsl:value-of select="$transformation-end-time" /></prov:endTime>
				<prov:wasAssociatedWith>
					<xsl:if test="normalize-space($generated-by-pipeline) != ''">
						<prov:plan prov:ref="{$generated-by-pipeline}" />
					</xsl:if>
					<xsl:if test="normalize-space($generated-by-user) != ''">
						<prov:agent prov:ref="{$generated-by-user}" />
					</xsl:if>
				</prov:wasAssociatedWith>    	
			</prov:activity>    	

			<xsl:if test="normalize-space($generated-by-pipeline) != ''">
				<prov:plan prov:id="{$generated-by-pipeline}">
					<prov:location><xsl:value-of select="$generated-by-pipeline" /></prov:location>
				</prov:plan>    	
			</xsl:if>
			
			<!-- source document -->
			<xsl:apply-templates select="*/prov:document" mode="provenance-xml" />  
			
		</prov:document>    		
	</xsl:template>
	
	<xsl:template match="@generated-by-pipeline" mode="provenance-xml.agent">
		<prov:agent prov:ref="{.}" />
	</xsl:template>
	
	<xsl:template match="@generated-by-user" mode="provenance-xml.entity">
		<prov:person prov:id="{.}" />
	</xsl:template>
    
    <xsl:template match="prov:document" mode="provenance-xml">
    	<xsl:variable name="id" select="if (@uuid) then concat('SAP-', @uuid) else @xml:id" as="xs:string" />
    	
    	<prov:wasDerivedFrom>
    		<prov:entity prov:ref="{$id}" />
    	</prov:wasDerivedFrom>
    	<prov:entity prov:id="{$id}">
    		<xsl:copy-of select="@hash, node()" />
    	</prov:entity>
    </xsl:template>
    
</xsl:stylesheet>
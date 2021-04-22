<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all"
    version="3.0">
	
	<xsl:variable name="source-uri" select="document-uri(/)" as="xs:string" />
  
    <xsl:template match="prov:document[not(@prov:id)]" mode="provenance-xml">
    	<prov:entity prov:id="{$source-uri}">
    		<xsl:apply-templates mode="#current" />
    	</prov:entity>
    </xsl:template>
	
	<xsl:template match="document-node()" mode="provenance-xml">
		<xsl:param name="stylesheet-id" select="resolve-uri('')" as="xs:anyURI" />
		<xsl:param name="transformation-id" select="generate-id()" as="xs:string" />
		<xsl:param name="transformation-start-time" select="current-dateTime()" as="xs:dateTime" />
		<xsl:param name="generated-by-user" as="xs:string?" />
		<xsl:param name="generated-by-pipeline" as="xs:string?" />
				
		<prov:document>
			
			<!-- result document -->
			<prov:wasGeneratedBy>
				<prov:entity prov:ref="{$stylesheet-id}" />
				<prov:activity prov:ref="{$transformation-id}" />
			</prov:wasGeneratedBy>    				   
			
			<prov:entity prov:id="{$stylesheet-id}" />
			
			<prov:activity prov:id="{$transformation-id}">
				<prov:startTime><xsl:value-of select="current-dateTime()" /></prov:startTime>
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
			<xsl:apply-templates select="file, */prov:document" mode="provenance-xml" />  
			
		</prov:document>    
	</xsl:template>
	
	
	<xsl:template match="file" mode="provenance-xml">
		<prov:wasDerivedFrom>
			<prov:entity prov:ref="{$source-uri}" />
		</prov:wasDerivedFrom>
		
		<prov:entity prov:id="{$source-uri}">
			
			<prov:wasDerivedFrom>
				<prov:entity prov:ref="{@derived-from}" />	
			</prov:wasDerivedFrom>    					
			
			<prov:wasGeneratedBy>
				<prov:entity prov:ref="{@stylesheet-uri}" />
				<prov:activity prov:ref="{@transformation-id}" />
			</prov:wasGeneratedBy>
			
			<prov:entity prov:id="{@stylesheet-uri}" />    					
			
			<prov:activity prov:id="{@transformation-id}">
				<prov:startTime><xsl:value-of select="@transformation-start-time" /></prov:startTime>
				<prov:endTime><xsl:value-of select="@transformation-end-time" /></prov:endTime>
				<prov:wasAssociatedWith>
					<prov:plan prov:ref="{@generated-by-pipeline}" />
					<xsl:apply-templates select="@generated-by-user[normalize-space(.) != '']" mode="provenance-xml.agent" />
				</prov:wasAssociatedWith>    
			</prov:activity>								    					  		
			
			<prov:plan prov:id="{@generated-by-pipeline}">
				<prov:location><xsl:value-of select="@generated-by-pipeline" /></prov:location>
			</prov:plan>
			
			<xsl:apply-templates select="@generated-by-user[normalize-space(.) != '']" mode="provenance-xml.entity" />					
			
		</prov:entity>
	</xsl:template>
	
	<xsl:template match="@generated-by-user" mode="provenance-xml.agent">
		<prov:agent prov:ref="{.}" />
	</xsl:template>
	
	<xsl:template match="@generated-by-user" mode="provenance-xml.entity">
		<prov:person prov:id="{.}" />
	</xsl:template>
    
    <xsl:template match="prov:document" mode="provenance-xml">
    	<prov:entity>
    		<xsl:copy-of select="@*" />
    		<xsl:copy-of select="node()" />
    	</prov:entity>
    </xsl:template>
    
</xsl:stylesheet>
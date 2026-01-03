<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">             
	
	<xsl:import href="../../../../utils/identity.xsl" />
	
	<xsl:output indent="yes" />    
    
	<xsl:variable name="dna-subject-ancestry-url" select="/file/record[Relationship = 'DNA Subject']/Ancestry-DNA-Match-to-url" as="xs:string" />
	<xsl:variable name="dna-subject-ancestry-tree-id" select="fn:get-tree-id-from-ancestry-url($dna-subject-ancestry-url)" />
    
    <xsl:template match="/dna-data">
    	<dna-analysis>
    		<xsl:apply-templates select="@*, node()[not(self::* and local-name() = 'record')]" />
    		<dna-testers>
    			<xsl:apply-templates select="match" />
    		</dna-testers>
    	</dna-analysis>
    </xsl:template>
    
	<xsl:template match="match">	
		<xsl:variable name="person-id" select="fn:get-person-id-from-ancestry-url(user/@profile)" as="xs:string?" />
		
		<dna-match id="ANC-{$person-id}">
			<name><xsl:value-of select="user" /></name>
			<dna-service>
				<name>Ancestry DNA</name>
				<profile id="{$person-id}" />
				
				<total-shared-centimorgans>
					<xsl:apply-templates select="@shared-cm" mode="ancestry-profile" />
				</total-shared-centimorgans>
				<xsl:apply-templates select="tree" mode="ancestry-profile" />
				<xsl:apply-templates select="following-sibling::Ancestry-Linked-Tree-Type[. != '']" mode="ancestry-profile" />
				<xsl:apply-templates select="following-sibling::Ancestry-Leeds-Groups[. != '']" mode="ancestry-profile" />
			</dna-service>
		</dna-match>
	</xsl:template>
	
	
	<xsl:template match="match/@shared-cm" mode="ancestry-profile">
		<xsl:attribute name="weighted" select="." />
	</xsl:template>
	
	<xsl:template match="tree" mode="ancestry-profile">
		<tree>
			<xsl:apply-templates select="@*" />
		</tree>
	</xsl:template>
	
	
	<xsl:template match="tree/@people">
		<xsl:attribute name="total-people" select="translate(., ',', '')" />
	</xsl:template>
	
	

	<xsl:function name="fn:get-person-id-from-ancestry-url" as="xs:string?">
		<xsl:param name="url" as="xs:string?" />
		
		<xsl:choose>
			<xsl:when test="contains($url, '/compare/')">
				<xsl:value-of select="substring-after($url, '/with/')" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="tokenize(substring-after($url, 'cfpid='), '&amp;')[1]" />
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:function>

	<xsl:function name="fn:get-tree-id-from-ancestry-url" as="xs:string?">
		<xsl:param name="url" as="xs:string?" />
		
		<xsl:value-of select="tokenize(substring-after($url, '/family-tree/tree/'), '/')[1]" />
	</xsl:function>

</xsl:stylesheet>
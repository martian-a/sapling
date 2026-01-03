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
    
	<xsl:variable name="dna-subject-ancestry-tree-url" select="/file/record[Relationship = 'DNA Subject']/Ancestry-DNA-Match-to-Tree-URL" as="xs:string" />
	<xsl:variable name="dna-subject-ancestry-tree-id" select="fn:get-tree-id-from-ancestry-tree-url($dna-subject-ancestry-tree-url)" />
    
    <xsl:template match="/file">
    	<dna-analysis>
    		<xsl:apply-templates select="@*, node()[not(self::* and local-name() = 'record')]" />
    		<dna-testers>
    			<xsl:apply-templates select="record" />
    		</dna-testers>
    	</dna-analysis>
    </xsl:template>
    
	<xsl:template match="record">	
		<xsl:variable name="is-dna-subject" select="if (Relationship = 'DNA Subject') then true() else false()" as="xs:boolean" />
		<xsl:variable name="person-id" select="fn:get-person-id-from-ancestry-tree-url(Ancestry-DNA-Match-to-Tree-URL)" as="xs:string?" />
		
		<xsl:element name="{if ($is-dna-subject = true()) then 'dna-subject' else 'dna-match'}">
			<xsl:apply-templates select="Match-ID">
				<xsl:with-param name="is-dna-subject" select="$is-dna-subject" as="xs:boolean" tunnel="true" />
				<xsl:with-param name="person-id" select="$person-id" as="xs:string?" tunnel="true" />
			</xsl:apply-templates>
		</xsl:element>
	</xsl:template>
	
	<xsl:template match="Match-ID">
		<xsl:if test="text() != ''">
			<xsl:attribute name="id" select="." />
		</xsl:if>
		<xsl:apply-templates select="following-sibling::node()" />
	</xsl:template>
	
	<xsl:template match="Relative">
		<name><xsl:apply-templates /></name>
	</xsl:template>

	<xsl:template match="Relationship | Notes">
		<xsl:if test=". != ''">
			<xsl:element name="{lower-case(local-name())}">
				<xsl:apply-templates />
			</xsl:element>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Common-Ancestor-with-DNA-Subject">
		<xsl:if test=". != ''">
			<common-ancestors-list>
				<xsl:for-each select="tokenize(., ';') ! normalize-space(.)">
					<common-ancestors>
						<xsl:value-of select="." />
					</common-ancestors>
				</xsl:for-each>
			</common-ancestors-list>
		</xsl:if>			
	</xsl:template>
	
	<xsl:template match="Ancestry-DNA-Profile-ID">
		<dna-service>
			<name>Ancestry DNA</name>
			<xsl:if test=". != ''">
				<profile id="{.}" />
			</xsl:if>
			<xsl:apply-templates select="UcM" mode="ancestry-profile" />
			<xsl:apply-templates select="following-sibling::Ancestry-DNA-Match-to-Tree-URL[. != '']" mode="ancestry-profile" />
			<xsl:apply-templates select="following-sibling::Ancestry-Linked-Tree-Type[. != '']" mode="ancestry-profile" />
			<xsl:apply-templates select="following-sibling::Ancestry-Leeds-Groups[. != '']" mode="ancestry-profile" />
		</dna-service>
	</xsl:template>
	
	<xsl:template match="ftDNA-Profile-ID">
		<dna-service>
			<name>Family Tree DNA (ftDNA)</name>		
			<xsl:if test=". != ''">
				<profile id="{.}" />
			</xsl:if>
			<xsl:apply-templates select="following-sibling::ftDNA-Leeds-Groups" mode="ancestry-profile" />
		</dna-service>
	</xsl:template>	
	
	<xsl:template match="UcM" mode="ancestry-profile">
		<total-shared-centimorgans unweighted="{.}">
			<xsl:apply-templates select="following-sibling::ancestryCm" mode="#current" />
		</total-shared-centimorgans>
	</xsl:template>
	
	<xsl:template match="ancestryCm" mode="ancestry-profile">
		<xsl:attribute name="weighted" select="." />
	</xsl:template>
	
	<xsl:template match="Ancestry-DNA-Match-to-Tree-URL" mode="ancestry-profile">
		<tree tree-id="{fn:get-tree-id-from-ancestry-tree-url(.)}">
			<match-in-tree url="{.}" person-id="{fn:get-person-id-from-ancestry-tree-url(.)}" />
		</tree>
	</xsl:template>
	
	<xsl:template match="Ancestry-Linked-Tree-Type" mode="ancestry-profile">
		<xsl:if test="not(. = 'No Trees')">
			<xsl:variable name="linked" select="if (. = 'Public linked') then true() else false()" as="xs:boolean" />
			<xsl:variable name="public" select="if (. = 'Public linked') then true() else false()" as="xs:boolean" />
			
			<tree>
				<xsl:attribute name="linked" select="$linked" />
				<xsl:attribute name="public" select="$public" />
				<xsl:apply-templates select="following-sibling::Total-People-in-Ancestry-Linked-Tree" mode="#current" />
			</tree>
		</xsl:if>
	</xsl:template>
	
	<xsl:template match="Total-People-in-Ancestry-Linked-Tree" mode="ancestry-profile">
		<xsl:attribute name="total-people" select="." />
	</xsl:template>
	
	<xsl:template match="Ancestry-Leeds-Groups | ftDNA-Leeds-Groups" mode="ancestry-profile">
		<leeds-method-results>
			<xsl:for-each select="tokenize(., ';') ! normalize-space(.)">
				<group>
					<anchor ref="{.}" />
				</group>
			</xsl:for-each>
		</leeds-method-results>
	</xsl:template>
	

	<xsl:template match="UcM | AcM | Has-Common-Ancestor | Ancestry-Leeds-Groups-Notes | Ancestry-DNA-Match-to-Tree-URL | Ancestry-Linked-Tree-Type | Total-People-in-Ancestry-Linked-Tree | Is-Ancestry-Leeds-Group-Anchor | Total-Ancestry-Leeds-Groups | Ancestry-Leeds-Groups | Is-ftDNA-Leeds-Group-Anchor | Total-ftDNA-Leeds-Groups | ftDNA-Leeds-Groups" />
	

	<xsl:function name="fn:get-person-id-from-ancestry-tree-url" as="xs:string?">
		<xsl:param name="url" as="xs:string?" />
		
		<xsl:value-of select="tokenize(substring-after($url, 'cfpid='), '&amp;')[1]" />
	</xsl:function>

	<xsl:function name="fn:get-tree-id-from-ancestry-tree-url" as="xs:string?">
		<xsl:param name="url" as="xs:string?" />
		
		<xsl:value-of select="tokenize(substring-after($url, '/family-tree/tree/'), '/')[1]" />
	</xsl:function>

</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"	
	xmlns:doc="http://ns.kaikoda.com/documentation/xml"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:void="http://rdfs.org/ns/void#"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:param name="resource-base-uri" select="concat('http://ns.thecodeyard.co.uk/data/sapling/', /*/prov:document/@xml:id)" />
	
	
	<xsl:variable name="statement-delimiter" select="codepoints-to-string((59, 10))"/>
	
	<xsl:variable name="tree-id" as="xs:string">
		<xsl:apply-templates select="/data/prov:document/prov:wasDerivedFrom" mode="tree-id" />
	</xsl:variable>
	
	<xsl:template match="prov:wasDerivedFrom" mode="tree-id">
		<xsl:variable name="entity-id" select="prov:entity/@prov:ref" as="xs:string" />
		<xsl:choose>
			<xsl:when test="parent::*/prov:entity[prov:wasDerivedFrom]/@prov:id = $entity-id">
				<xsl:apply-templates select="parent::*/prov:entity[@prov:id = $entity-id]/prov:wasDerivedFrom" mode="tree-id" />
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$entity-id" />
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
		
	<xsl:output indent="yes" encoding="UTF-8" method="xml" version="1.0" />
	
	
	<xsl:template match="/" mode="html-head">
		<xsl:param name="title" as="xs:string?" />
		<head>
			<title><xsl:value-of select="$title" /> (<xsl:value-of select="data/void:dataset/@void:name" />)</title>
			<xsl:apply-templates select="(/*/void:dataset/@void:name, /*/@void:name)[1]" mode="html-head" />
			<xsl:apply-templates select="/*/*:document/*:activity/*:startTime" mode="html-head" />
			<xsl:apply-templates select="(/*/void:dataset/@subset-name, /*/@subset-name)[1]" mode="html-head" />
			<style><xsl:comment>
				tr.subject > * { background-color: #F5F5F5; font-weight: bold; }
				tr.partner > * { border-top: solid 1px silver; }				
				th, td { padding: .5em; }
				table .gender { text-align: center; }
				table .age { text-align: right; }
				table .birth-year { text-align: center; }
				table .death-year { text-align: center; }
			</xsl:comment></style>
		</head>
	</xsl:template>
	
	<xsl:template match="@void:name" mode="html-head">
		<meta name="dataset-name" content="{.}" />
	</xsl:template>
	<xsl:template match="@subset-name" mode="html-head">
		<meta name="subset-name" content="{.}" />
	</xsl:template>
	<xsl:template match="*:startTime" mode="html-head">
		<meta name="dataset-creation-date" content="{.}" />
	</xsl:template>
	
</xsl:stylesheet>
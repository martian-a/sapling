<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"    
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="../shared.xsl" />
    	
	<xsl:variable name="with-node-for-parent-group" select="'false'" />    	
    	
    <xsl:template match="/data">        
		<xsl:apply-templates select="people" />        	
    	<xsl:apply-templates select="events" />
    </xsl:template>
    
    <xsl:template match="people">
        <nodes>
            <xsl:apply-templates select="person" />
        </nodes>
    </xsl:template>
    
    <xsl:template match="person[@id]">
        <node id="{@id}">
            <xsl:value-of select="fn:normalise-persona-name(fn:get-default-person-name(self::person))" />
        </node>
    </xsl:template>
    
    <xsl:template match="events">
        <edges>
        	<xsl:for-each-group select="event[person][parent]" group-by="string-join((person/@ref, sort(parent/@ref)), '-')">
        		<xsl:variable name="person-id" select="person/@ref" as="xs:string" />
        		<xsl:for-each select="parent">
        			<edge id="{$person-id}-{@ref}">
        				<node ref="{@ref}" role="source" />
        				<node ref="{$person-id}" role="target" />        				
        			</edge>     
        		</xsl:for-each>
        	</xsl:for-each-group>
        </edges>
    </xsl:template>
    
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"    
    exclude-result-prefixes="#all"
    version="3.0">
    
 	<xsl:import href="../shared.xsl" />
	
	<xsl:variable name="with-node-for-parent-group" select="'true'" />
	
	<xsl:template match="/data">
        <nodes>
            <xsl:apply-templates select="people/person" />
        	<xsl:apply-templates select="events" />
        </nodes>
        <xsl:apply-templates select="events" mode="edge" />
    </xsl:template>
    
    
    <xsl:template match="person[@id]">
        <node id="{@id}">
            <xsl:value-of select="fn:normalise-persona-name(fn:get-default-person-name(self::person))" />
        </node>
    </xsl:template>
	
	<xsl:template match="events">
		<xsl:for-each-group select="event[person][parent]" group-by="string-join(sort(parent/@ref), '-')">
			<node id="{current-grouping-key()}">
				<xsl:value-of select="string-join(/data/people/person[@id = current()/parent/@ref]/fn:normalise-persona-name(fn:get-default-person-name(self::person)), ' = ')" />				
			</node>
		</xsl:for-each-group>		
	</xsl:template>
    
    <xsl:template match="events" mode="edge">
        <edges>
        	<xsl:variable name="first-pass" as="element()*">
	        	<xsl:for-each-group select="event[person][parent]" group-by="string-join((person/@ref, sort(parent/@ref)), '-')">
	        		<xsl:variable name="couple-id" select="string-join(sort(parent/@ref), '-')" as="xs:string" />     		
	        		<edge id="{current-grouping-key()}">
	        			<node ref="{$couple-id}" role="source" />
	        			<node ref="{person/@ref}" role="target" />
	        		</edge>        		
	        		<xsl:for-each select="parent">
	        			<edge id="{ancestor::event/person/@ref}-{@ref}">
	        				<node ref="{$couple-id}" role="source" />
	        				<node ref="{@ref}" role="target" />
	        			</edge>     
	        		</xsl:for-each>
	        	</xsl:for-each-group>
        	</xsl:variable>
        	<xsl:for-each-group select="$first-pass" group-by="string-join(node/@ref, '#')">
        		<xsl:copy-of select="current-group()[1]" />
        	</xsl:for-each-group>
        </edges>
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
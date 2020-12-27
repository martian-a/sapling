<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:import href="default.xsl" />
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">
        <xsl:variable name="document-uri" select="(document-uri(/), /*/@href)[1]" as="xs:string?" />
        <data>
            <xsl:if test="$document-uri != ''">
                <xsl:attribute name="href" select="$document-uri" />
                <xsl:attribute name="filename" select="tokenize(translate($document-uri, '\', '/'), '/')[last()]" />
            </xsl:if>
            <people><xsl:apply-templates select="file/individual" mode="people" /></people>
            <events>
                <xsl:apply-templates select="file/individual/birth" mode="events" />
                <xsl:apply-templates select="file/individual[not(birth)]/family-child" mode="events" />
                <xsl:apply-templates select="file/individual/death" mode="events" />
            </events>            
        </data>
    </xsl:template>       
    
    <xsl:include href="person.xsl" />
    <xsl:include href="events.xsl" />
    
    <xsl:template match="source-citation" mode="reference" priority="10">
        <source ref="{@ref}">
            <summary><xsl:next-match /></summary>
        </source>
    </xsl:template>
    
    
    
</xsl:stylesheet>
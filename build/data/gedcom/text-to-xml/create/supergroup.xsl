<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">                   
    
    <xsl:template match="/file">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates select="record[group]" />
        </xsl:copy>
    </xsl:template>
    
    <xsl:template match="file/record">
        <xsl:element name="{@type}">
            <xsl:copy-of select="@*[local-name() != 'type']" />
            <xsl:sequence select="fn:group(group)" />
        </xsl:element>
    </xsl:template>    
    
    <xsl:function name="fn:group" as="element()*">
        <xsl:param name="super-group" as="element()*" />
        
        <xsl:for-each-group select="$super-group" group-starting-with="self::*[@level = $super-group[1]/@level]">
            <xsl:variable name="current-level" select="current-group()[1]/@level" as="xs:integer" />
            <xsl:for-each select="current-group()/line[@level = $current-level]">
                <xsl:variable name="descendants" select="current-group()[not(line[@level = $current-level])]" as="element()*" />
                <xsl:element name="{@label}">
                    <xsl:choose>
                        <xsl:when test="position() = last() and $descendants">
                            <value><xsl:apply-templates /></value>
                        </xsl:when>
                        <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
                    </xsl:choose>
                    <xsl:if test="position() = last() and $descendants">
                        <xsl:sequence select="fn:group($descendants)" />                        
                    </xsl:if>                    
                </xsl:element>   
            </xsl:for-each>
        </xsl:for-each-group>
        
    </xsl:function>
    
    
    <xsl:template match="document-node() | * | comment() | processing-instruction()">
        <xsl:copy>
            <xsl:copy-of select="@*" />
            <xsl:apply-templates />
        </xsl:copy>
    </xsl:template> 
    
</xsl:stylesheet>

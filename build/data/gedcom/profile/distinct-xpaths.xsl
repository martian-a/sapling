<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <!-- Use on *.5.xml, once record[@type][@id] structure has been introduced -->
    
    <xsl:output indent="yes" />
    
    <xsl:template match="/">
        <xsl:variable name="distinct-paths" as="element()*">
            <xsl:for-each-group select="descendant::*[not(*)]" group-by="string-join((ancestor-or-self::*/name(), if (normalize-space(.) != '') then 'text()' else ()), '/')">
                <xsl:sort select="count(current-group())" data-type="number" order="descending" />
                <xsl:sort select="current-grouping-key()" data-type="text" order="ascending" />
                
                <path occurrences="{count(current-group())}">
                    <xsl:value-of select="current-grouping-key()"/>
                </path>
                
            </xsl:for-each-group>
        </xsl:variable>
        
        <paths href="{document-uri(/)}">
            <frequency>
                <xsl:copy-of select="$distinct-paths" />
            </frequency>
            <elements>
                <xsl:variable name="nodes" select="distinct-values($distinct-paths/tokenize(text(),'/'))" as="xs:string*" />
                <xsl:for-each select="$nodes">
                    <xsl:sort select="lower-case(current())" data-type="text" order="ascending" />
                    <node name="{current()}">
                        <xsl:variable name="matching-paths" select="$distinct-paths[contains(text(), current())]" as="element()*" />
                        <xsl:choose>
                            <xsl:when test="count($matching-paths) eq count($distinct-paths)">
                                <xsl:attribute name="in-all-paths" select="true()" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="in-all-paths" select="false()" />
                                <xsl:sequence select="$matching-paths" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </node>
                </xsl:for-each>
            </elements>
        </paths>
            
        
    </xsl:template>
    
</xsl:stylesheet>
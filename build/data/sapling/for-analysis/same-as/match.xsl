<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:bio="http://purl.org/vocab/bio/0.1/"
    xmlns:foaf="http://xmlns.com/foaf/0.1/"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:owl="http://www.w3.org/2002/07/owl#"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:rel="http://purl.org/vocab/relationship/"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="xs"
    version="2.0">
    
    <xsl:param name="other-graph-href" />
    
    <xsl:key name="person" match="/rdf:RDF/foaf:Person" use="@rdf:about" />
    <xsl:key name="birth" match="/rdf:RDF/bio:Birth" use="bio:principal/@rdf:resource" />
    <xsl:key name="child" match="/rdf:RDF/foaf:Person" use="rel:childOf/@rdf:resource" />
    
    <xsl:output method="xml" indent="yes" />
    
    <xsl:import href="../../../../../cenizaro/tools/identity.xsl" />
    
    
    <xsl:template match="foaf:Person[foaf:*]">
        <xsl:variable name="primary" select="self::*" as="element()" />
        <xsl:variable name="potential-matches" select="document($other-graph-href)/rdf:RDF/foaf:Person[foaf:*]" as="element()*" />
        <xsl:copy>
            <xsl:apply-templates select="@*, *" />            
            <xsl:for-each select="$potential-matches">
                <xsl:if test="fn:same-as($primary, current())">
                    <owl:sameAs rdf:resource="{current()/@rdf:about}" />
                </xsl:if>
            </xsl:for-each>
        </xsl:copy>    
    </xsl:template>
    
    
    <xsl:function name="fn:same-as" as="xs:boolean">
        <xsl:param name="person-1" />
        <xsl:param name="person-2" />

        <xsl:sequence select="fn:same-as($person-1, $person-2, true(), true())" />
        
    </xsl:function>
    
    <xsl:function name="fn:same-as" as="xs:boolean">
        <xsl:param name="person-1" />
        <xsl:param name="person-2" />
        <xsl:param name="check-parents" as="xs:boolean" />
        <xsl:param name="check-children" as="xs:boolean" />
        
            <xsl:variable name="score" as="xs:decimal*">
                <xsl:choose>
                    <xsl:when test="$person-1/foaf:name = $person-2/foaf:name">5</xsl:when>
                    <xsl:otherwise>
                        <xsl:if test="$person-1/foaf:familyName[1] = $person-2/foaf:familyName[1]">2.5</xsl:if>
                        <xsl:if test="$person-1/foaf:givenName[1] = $person-2/foaf:givenName[1]">2.5</xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:if test="$person-1/foaf:birthday = $person-2/foaf:birthday">5</xsl:if>
                <xsl:if test="$check-children">
                    <xsl:variable name="person-1-children" select="$person-1/key('child', $person-1/@rdf:about)" as="element()*" />
                    <xsl:variable name="person-2-children" select="$person-2/key('child', $person-2/@rdf:about)" as="element()*" />
                    <xsl:variable name="child-score" as="xs:decimal*">
                        <xsl:for-each select="$person-1-children">
                            <xsl:variable name="person-1-child" select="current()" as="element()" />
                            <xsl:for-each select="$person-2-children">
                                <xsl:variable name="person-2-child" select="current()" as="element()" />
                                <xsl:if test="fn:same-as($person-1-child, $person-2-child, false(), false())">5</xsl:if>
                            </xsl:for-each>
                        </xsl:for-each>
                    </xsl:variable>
                    <xsl:if test="sum($child-score) > 4">5</xsl:if>
                </xsl:if>
                <xsl:if test="$check-parents">
                    <xsl:variable name="person-1-parents" select="$person-1/ancestor::rdf:RDF/foaf:Person[@rdf:about = $person-1/rel:childOf/@rdf:resource]" as="element()*" />
                    <xsl:variable name="person-2-parents" select="$person-2/ancestor::rdf:RDF/foaf:Person[@rdf:about = $person-2/rel:childOf/@rdf:resource]" as="element()*" />
                    <xsl:for-each select="$person-1-parents">
                        <xsl:variable name="person-1-parent" select="current()" as="element()" />
                        <xsl:for-each select="$person-2-parents">
                            <xsl:variable name="person-2-parent" select="current()" as="element()" />
                            <xsl:if test="fn:same-as($person-1-parent, $person-2-parent, false(), false())">2.5</xsl:if>
                        </xsl:for-each>
                    </xsl:for-each>
                </xsl:if>
            </xsl:variable>
                    
            <xsl:sequence select="if (sum($score) > 9) then true() else false()" />        
        
    </xsl:function>
    
</xsl:stylesheet>
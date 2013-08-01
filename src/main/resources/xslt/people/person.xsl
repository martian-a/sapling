<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://ns.kaikoda.com/xslt/functions"
    exclude-result-prefixes="xs fn"
    version="2.0">
    
    <xsl:variable name="person-id" select="/sapling/person/@id" />
    <xsl:variable name="primary-doc" select="/sapling" /> 
               
    
    <xsl:template match="persona/name">
        <xsl:for-each select="name">
            <xsl:value-of select="." />
            <xsl:if test="position() != last()"><xsl:text> </xsl:text></xsl:if>
        </xsl:for-each>
    </xsl:template>
    
    <xsl:template match="persona/gender">
        <p class="gender"><xsl:value-of select="." /></p>
    </xsl:template>    	 
    
    <xsl:template match="person" mode="birth-year-approx">
        <xsl:variable name="dates" as="document-node()">
            <xsl:document>
                <list>
                    <xsl:copy-of select="//event[@type = 'birth'][person/@ref = current()/@id]" />
                    <xsl:copy-of select="//event[@type = 'christening'][person/@ref = current()/@id]" />
                    <event type="approximate-birth">
                        <date year="{current()/@year}" />
                    </event>
                </list>
            </xsl:document>
        </xsl:variable>        
        
        <xsl:value-of select="$dates/list/event[date/@year[. != '']][1]/date/@year" />
    </xsl:template>
    
    <xsl:template match="person" mode="death-year">
        <xsl:value-of select="//event[@type = 'death'][person/@ref = current()/@id]/date/@year" />
    </xsl:template>

    <xsl:template match="related/events/event[@type = 'birth'][person/@ref = $person-id]" mode="description">
        <xsl:variable name="parents" as="document-node()">
            <xsl:document>
                <list>
                    <xsl:copy-of select="parent[@type = 'biological']" />
                </list>
            </xsl:document>
        </xsl:variable>        
                
        <xsl:text>Born, to </xsl:text>
        <xsl:apply-templates select="$parents/list" />
        <xsl:text>.</xsl:text>        
    </xsl:template>
    
    <xsl:template match="related/events/event[@type = 'birth'][parent[@type = 'biological']/@ref = $person-id]" mode="description">
        <xsl:variable name="parents" as="document-node()">
            <xsl:document>
                <list>
                    <xsl:copy-of select="parent[@type = 'biological'][@ref = $person-id]" />
                    <xsl:copy-of select="parent[@type = 'biological'][@ref != $person-id]" />
                </list>
            </xsl:document>
        </xsl:variable>                   
        
        <xsl:choose>
            <xsl:when test="normalize-space(person/@ref) != ''">
                <xsl:apply-templates select="ancestor::related[1]/people/person[@id = current()/person/@ref]" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>A child</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> is born</xsl:text>
        <!-- xsl:if test="$parents/list/*">
            <xsl:text> to </xsl:text>
            <xsl:apply-templates select="$parents/list" />
        </xsl:if -->                        
        <xsl:text >.</xsl:text>
    </xsl:template>

    <xsl:template match="related/events/event[@type = 'marriage'][person/@ref = $person-id]" mode="description">
        <xsl:variable name="partners" as="document-node()">
            <xsl:document>
                <list>
                    <xsl:copy-of select="person[@ref != $person-id]" />
                </list>
            </xsl:document>
        </xsl:variable>        
                
        <xsl:text>Married</xsl:text>
        <xsl:if test="$partners/list/person"><xsl:text> </xsl:text></xsl:if>        
        <xsl:apply-templates select="$partners/list" />
        <xsl:text>.</xsl:text>        
    </xsl:template>

    <xsl:template match="location[@id]">        
        <a class="location" href="/locations/{substring-after(@id, 'LOC')}"><xsl:value-of select="name" /></a>
    </xsl:template>
    
    <xsl:template match="location[@ref]">
        <xsl:apply-templates select="//location[@id = current()/@ref]" />
    </xsl:template>
    
    <xsl:template match="person[@id]">        
        <a class="person" href="/people/{substring-after(@id, 'PER')}"><xsl:apply-templates select="persona[1]/name" /></a>
    </xsl:template>
    
    <xsl:template match="person[@id]/persona">        
        <a class="person" href="/people/{substring-after(ancestor::person[1]/@id, 'PER')}"><xsl:apply-templates select="name" /></a>
    </xsl:template>
    
    <xsl:template match="person[@ref] | parent[@ref]">
        <xsl:choose>
            <xsl:when test="@ref = $person-id">                
                <xsl:apply-templates select="$primary-doc/person[@id = $person-id]/persona[1]/name" />
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$primary-doc/*/related[1]/people/person[@id = current()/@ref]" />
            </xsl:otherwise>
        </xsl:choose>        
    </xsl:template>
    
    <xsl:template match="list">
        <xsl:for-each select="*">            
            <xsl:choose>
                <xsl:when test="preceding-sibling::* and position() = last()">
                    <xsl:text> and </xsl:text>
                </xsl:when>
                <xsl:when test="position() != 1">
                    <xsl:text>, </xsl:text>
                </xsl:when>                
            </xsl:choose>            
            <xsl:apply-templates select="." />
        </xsl:for-each>                
    </xsl:template>
        
    <xsl:template match="notes/descendant::*[not(name() = ('person', 'parent') and @ref)]">
        <xsl:element name="{name()}"><xsl:apply-templates /></xsl:element>
    </xsl:template>
    
    <xsl:template match="notes/descendant::text()"><xsl:value-of select="." /></xsl:template>
	
	<xsl:function name="fn:getShortMonthName" as="text()">
		<xsl:param name="monthNumber" as="xs:integer?" />
	
		<xsl:choose>
			<xsl:when test="$monthNumber = 1">Jan</xsl:when>
			<xsl:when test="$monthNumber = 2">Feb</xsl:when>
			<xsl:when test="$monthNumber = 3">Mar</xsl:when>
			<xsl:when test="$monthNumber = 4">Apr</xsl:when>
			<xsl:when test="$monthNumber = 5">May</xsl:when>
			<xsl:when test="$monthNumber = 6">Jun</xsl:when>
			<xsl:when test="$monthNumber = 7">Jul</xsl:when>
			<xsl:when test="$monthNumber = 8">Aug</xsl:when>
			<xsl:when test="$monthNumber = 9">Sep</xsl:when>
			<xsl:when test="$monthNumber = 10">Oct</xsl:when>
			<xsl:when test="$monthNumber = 11">Nov</xsl:when>
			<xsl:when test="$monthNumber = 12">Dec</xsl:when>
			<xsl:otherwise><xsl:value-of select="$monthNumber" /></xsl:otherwise>
		</xsl:choose>
		
	</xsl:function>
    
    <xsl:function name="fn:getPersonId" as="xs:integer?">
        <xsl:param name="prefixedId" as="xs:string?" />
        
        <xsl:value-of select="substring-after($prefixedId, 'PER')" />        
    </xsl:function>    
    
</xsl:stylesheet>
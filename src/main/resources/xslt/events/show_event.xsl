<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:kai="http://ns.kaikoda.com/xslt/functions"
    exclude-result-prefixes="xs kai"
    version="2.0">
   
    <xsl:import href="../global.xsl" />
    
    <xsl:param name="root-publication-directory" select="''" />
    
    <xsl:template match="/">
        <xsl:apply-templates select="/sapling/event" mode="profile" />
    </xsl:template>
    
    <xsl:template match="event" mode="profile">
    	<xsl:variable name="publication-path" select="concat($root-publication-directory, 'events/', kai:getEventId(@id), '.html')" />
    
        <xsl:result-document href="{$publication-path}" format="xhtml" encoding="utf-8">
            <html id="event">
                <head>
                    <title><xsl:apply-templates select="." mode="document.title" /></title>             
                </head>
                <body>
                    <article class="event">
                    	<h1><xsl:value-of select="kai:getEventTypeLabel(@type)" /></h1>
                        <xsl:apply-templates select="." mode="description" />                          
                    </article>
                </body>
            </html>        
        </xsl:result-document>
    	
    	<sapling>
    		<link href="file:{escape-html-uri(($publication-path))}" />
    	</sapling>
    	
    </xsl:template>
    
    <xsl:variable name="event" select="/sapling/event"/>
    
    <xsl:variable name="event-month-long" as="text()?">
        <xsl:apply-templates select="$event/date/@month" mode="event-month-long" />
    </xsl:variable>
    
    <xsl:template match="event" mode="document.title">
        <xsl:if test="normalize-space(date/@year) != ''">
            <xsl:value-of select="$event-month-long" />
            <xsl:if test="$event-month-long != ''">, </xsl:if>
            <xsl:value-of select="date/@year" />
            <xsl:text>: </xsl:text>           
        </xsl:if>
		<xsl:value-of select="kai:getEventTypeLabel(@type)" /> of <xsl:apply-templates select="related/people/person[@id = current()/person/@ref]/persona[1]/name" />
    </xsl:template>
    
    <xsl:template match="event" mode="description">
    	<p class="description">
    		<xsl:apply-templates select="date" mode="event-description" />
    		<xsl:text>a baby</xsl:text>
    		<xsl:apply-templates select="related/people/person[@id = current()/person/@ref]/persona[1]/gender" mode="event-description" />
    		<xsl:apply-templates select="related/people/person[@id = current()/person/@ref]/persona[1]" />
    		<xsl:text>, </xsl:text>
			<xsl:choose>
				<xsl:when test="@type = 'birth'">
					<xsl:text>was born</xsl:text>
					<xsl:if test="related/people/person[@id = current()/parent/@ref]/persona[1]/name">
						<xsl:text> to </xsl:text>
						<xsl:for-each select="related/people/person[@id = current()/parent/@ref]/persona[1]/name">
							<xsl:apply-templates select="ancestor::persona[1]" />
							<xsl:if test="position() != last()"> and </xsl:if>
						</xsl:for-each>
						<xsl:text>, </xsl:text>
					</xsl:if>
				</xsl:when>
			</xsl:choose>   
    		<xsl:apply-templates select="related/locations//location[@id = current()/location/@ref]" mode="event-description" />
    		<xsl:text>.</xsl:text>
    	</p>	    
    </xsl:template>
	
	<xsl:template match="gender" mode="event-description">
		<span class="gender">
			<xsl:choose>
				<xsl:when test=". = 'Male'"> boy</xsl:when>
				<xsl:when test=". = 'Female'"> girl</xsl:when>
			</xsl:choose>	
		</span>	
		<xsl:text>, </xsl:text>
	</xsl:template>
	
	<xsl:template match="location" mode="event-description">
		<xsl:text>in </xsl:text>
		<xsl:apply-templates select="." mode="relative-location" />
	</xsl:template>
	
	
	<xsl:template match="location" mode="relative-location">
		<xsl:apply-templates select="." />
		<xsl:if test="ancestor::location">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:apply-templates select="ancestor::location[1]" mode="relative-location" />
	</xsl:template>
	
	
	<xsl:template match="date" mode="event-description">
		<xsl:variable name="day-name" select="kai:getDayname(current())" as="xs:string?" />
		<xsl:variable name="normalised-day" select="normalize-space(@day)" as="xs:string?" />
		<xsl:variable name="normalised-month" select="normalize-space(@month)" as="xs:string?" />
		<xsl:variable name="normalised-year" select="normalize-space(@year)" as="xs:string?" />
		
		<xsl:choose>
			<xsl:when test="$normalised-day = '' and $normalised-month = '' and $normalised-year = ''"></xsl:when>
			<xsl:when test="$normalised-day = '' and $normalised-month = ''">
				<xsl:text>Sometime in </xsl:text><span class="date"><span clas="year"><xsl:value-of select="@year" /></span></span><xsl:text> </xsl:text>
			</xsl:when>
			<xsl:when test="$normalised-day = ''">
				<xsl:text>Sometime during </xsl:text><span class="date"><span class="month"><xsl:value-of select="kai:getLongMonthName(current())" /></span>, <span class="year"><xsl:value-of select="@year" /></span></span><xsl:text> </xsl:text>
			</xsl:when>
			<xsl:otherwise>
				<xsl:text>On</xsl:text>
				<span class="date">
					<xsl:if test="$day-name != ''"><xsl:text> </xsl:text><span class="day-name"><xsl:value-of select="$day-name" /></span></xsl:if>
					<xsl:text> the </xsl:text>
					<span class="day">
						<span class="number"><xsl:value-of select="$normalised-day"/></span>
						<span class="ordinal"><xsl:value-of select="kai:getOrdinal($normalised-day)" /></span>
					</span>
					<xsl:text> of </xsl:text>
					<span class="month"><xsl:value-of select="kai:getLongMonthName(current())" /></span>
					<xsl:text>, </xsl:text>
					<span class="year"><xsl:value-of select="$normalised-year" /></span>
				</span><xsl:text>, </xsl:text>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
    
</xsl:stylesheet>
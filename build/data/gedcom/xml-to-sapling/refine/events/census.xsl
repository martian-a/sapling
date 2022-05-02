<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:functx="http://www.functx.com"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="3.0">
    
    <xsl:output indent="yes" /> 
	
	<xsl:template match="/data/events">
		<xsl:copy>
			<xsl:apply-templates select="@*, node()" />
			<xsl:for-each select="/data/serials/serial[contains(lower-case(title), 'census')]">
				<xsl:variable name="census-year" select="(tokenize(title, ' ') ! normalize-space(.))[string-length(.) = 4][. castable as xs:integer]" as="xs:string?" />
				<xsl:variable name="census-sources" select="/data/sources/source[front-matter/serial/@ref = current()/@id]" as="element()*" />
				<xsl:for-each-group select="/data/events/event[sources/source/@ref = $census-sources/@id]" group-by="person/@ref">
					<event type="census">
						<date year="{$census-year}" />
						<person ref="{current-grouping-key()}" />
						<xsl:for-each-group select="current-group()[@type = 'residence']" group-by="location/@ref">
							<location ref="{current-grouping-key()}" />
						</xsl:for-each-group>
						<sources>
							<xsl:for-each select="$census-sources[@id = current-group()/sources/source/@ref]">
								<source ref="{@id}">
									<summary><xsl:value-of select="functx:capitalize-first(string-join(sort(distinct-values(current-group()/@type)), ', '))" /></summary>
								</source>
							</xsl:for-each>
						</sources>
					</event>					
				</xsl:for-each-group>
			</xsl:for-each>
		</xsl:copy>
	</xsl:template>
	
		
    <xsl:include href="../../../../../utils/identity.xsl" />
	
	<xsl:function name="functx:capitalize-first" as="xs:string?">
		<xsl:param name="arg" as="xs:string?"/>
		
		<xsl:sequence select="
			concat(upper-case(substring($arg,1,1)),
			substring($arg,2))
			"/>
		
	</xsl:function>
	
    
</xsl:stylesheet>
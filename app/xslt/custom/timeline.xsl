<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">
	
	<xsl:template match="related" mode="timeline" priority="10">
		<div class="timeline">
			<h2>Events</h2>
			<xsl:next-match />
		</div>
	</xsl:template>
	
	
	<xsl:template match="related | data/entities[event]" mode="timeline">
		<xsl:for-each-group select="event" group-by="not(date/@year)">
			<xsl:choose>
				<xsl:when test="current-grouping-key()">
					<div class="undated">
						<h3>Date Unknown</h3>
						<div class="timeline">
							<xsl:apply-templates select="current-group()" mode="timeline" />
						</div>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="dated">
						<h3>Date Known</h3>
						<div class="timeline">
							<xsl:apply-templates select="fn:sort-events(current-group())" mode="timeline" />
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
	</xsl:template>
	
	<xsl:template match="event" mode="timeline">
		<div class="event {@type} {if (position() mod 2 = 1) then 'odd' else 'even'}">
			<div class="icon"><xsl:apply-templates select="@type" mode="glyph" /></div>
			<div class="content">
				<xsl:apply-templates select="self::*" mode="timeline.date" />
				<xsl:apply-templates select="self::*" mode="summarise" />
			</div>
		</div>
	</xsl:template>
	
	
	<xsl:template match="event" mode="timeline.date">
		<div class="heading">
			<xsl:choose>
				<xsl:when test="not(date)">
					<span class="date unknown">Date Unknown</span>
				</xsl:when>
				<xsl:otherwise>
					<xsl:apply-templates select="date" />
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	
	<xsl:template match="event/@type" mode="glyph">
		<span class="glyph">
			<xsl:call-template name="href-html">
				<xsl:with-param name="path" select="concat('event/', parent::event/@id)" as="xs:string"/>
				<xsl:with-param name="content" as="xs:string?">
					<xsl:choose>
						<xsl:when test=". = 'birth'">☥</xsl:when>
						<xsl:when test=". = 'christening'">≈</xsl:when>
						<xsl:when test=". = 'adoption'">💗&#xFE0E;</xsl:when><!-- Growing Heart, plus variation character to force to black -->
						<xsl:when test=". = 'unmarried-partnership'">⚯</xsl:when>
						<xsl:when test=". = 'engagement'">⚬</xsl:when>
						<xsl:when test=". = 'marriage'">⚭</xsl:when>
						<xsl:when test=". = 'divorce'">⚮</xsl:when>
						<xsl:when test=". = 'death'">✝</xsl:when>
						<xsl:when test=". = 'historical'">📰</xsl:when>
						<xsl:otherwise />
					</xsl:choose>					
				</xsl:with-param>
			</xsl:call-template>
		</span>
	</xsl:template>
	
	
	
	
	
	

</xsl:stylesheet>
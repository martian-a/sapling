<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
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
						<div class="events">
							<xsl:apply-templates select="current-group()" mode="timeline" />
						</div>
					</div>
				</xsl:when>
				<xsl:otherwise>
					<div class="dated">
						<h3>Date Known</h3>
						<div class="events">
							<xsl:apply-templates select="current-group()" mode="timeline">
								<xsl:sort select="date/@year" data-type="number" order="ascending" />
								<xsl:sort select="date/@month" data-type="number" order="ascending" />
								<xsl:sort select="date/@day" data-type="number" order="ascending" />
							</xsl:apply-templates>
						</div>
					</div>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each-group>
	</xsl:template>
	
	<xsl:template match="event" mode="timeline">
		<div class="event {@type}">
			<xsl:apply-templates select="date" />
			<xsl:apply-templates select="self::*" mode="summarise" />
		</div>
	</xsl:template>

</xsl:stylesheet>
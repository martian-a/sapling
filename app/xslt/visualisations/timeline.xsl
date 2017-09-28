<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	xmlns:svg="http://www.w3.org/2000/svg"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
	version="2.0">
	
	<xsl:import href="network_graph.xsl"/>
	<xsl:output name="svg" method="xml" media-type="image/svg+xml" encoding="UTF-8" indent="yes"/>
	<xsl:template match="/app">
		<xsl:apply-templates select="view/data/person/related[event/date/@year]" />
	</xsl:template>
	
	<xsl:template match="related">
		<xsl:variable name="events" select="fn:sort-events(event[date/@year])" as="element()+" />	
		<xsl:variable name="start-date" as="xs:integer">
			<xsl:variable name="first-event-date" select="$events[1]/date/@year" as="xs:integer" />
			<xsl:variable name="padding" select="5 - ($first-event-date mod 5)" as="xs:integer" />
			<xsl:value-of select="$first-event-date - (if ($padding &lt; 5) then $padding + 5 else $padding)" />
		</xsl:variable>
		<xsl:variable name="end-date" as="xs:integer">
			<xsl:variable name="last-event-date"  select="$events[position() = last()]/date/@year" as="xs:integer" />
			<xsl:variable name="padding" select="5 - ($last-event-date mod 5)" as="xs:integer" />
			<xsl:value-of select="$last-event-date + (if ($padding &lt; 5) then $padding + 5 else $padding)"/>
		</xsl:variable>
		<xsl:variable name="duration-in-years" select="$end-date - $start-date" as="xs:integer" />
		<xsl:variable name="duration-in-months" select="$duration-in-years * 12" as="xs:integer" />
		<xsl:variable name="timeline-padding-x" select="20" as="xs:integer"/>
		<xsl:variable name="timeline-padding-y" select="60" as="xs:integer" />
		<xsl:variable name="start-x" select="$timeline-padding-x" as="xs:integer" />
		<xsl:variable name="end-x" select="$duration-in-months + $timeline-padding-x" as="xs:integer" />
		<xsl:variable name="font-family" select="'IM FELL DW Pica, DejaVu, serif'" as="xs:string" />	
		
		<xsl:result-document format="svg">
			
			<svg xmlns="http://www.w3.org/2000/svg" width="100%" preserveAspectRatio="none">
				<xsl:for-each-group select="$events" group-by="fn:get-continent(location)/name">
					
					<xsl:sort select="current-grouping-key()" data-type="text" order="ascending"/>
					<xsl:variable name="group-position" select="position()"/>	
					
					<xsl:variable name="start-y" select="($group-position * 20) + $timeline-padding-y" as="xs:integer"/>
					<xsl:variable name="end-y" select="$start-y" as="xs:integer"/>
					
					<g class="continent" id="{if (current-grouping-key() = '') then 'unknown' else lower-case(current-grouping-key())}">
					
					<text x="{$start-x - 5}" y="{$start-y}" text-anchor="end" fill="black" font-family="{$font-family}" font-size="4">
                        <xsl:value-of select="current-grouping-key()"/>
                    </text>
					<path d="M{$start-x} {$start-y} l {$duration-in-months} 0" stroke="black" stroke-width="1" fill="none"/>
						<!-- Timeline start point -->
						<circle cx="{$start-x}" cy="{$start-y}" r="1" fill="red"/>
						<!-- Timeline end point -->
						<circle cx="{$end-x}" cy="{$end-y}" r="1" fill="red"/>
						<xsl:if test="position() = last()">
						<!-- 10 year markers -->
						<xsl:for-each select="for $i in  0 to xs:integer(floor(($duration-in-months div 120))) return $i">
							<xsl:variable name="x" select="$start-x + (current() * 120)" as="xs:integer"/>
							<xsl:variable name="y" select="$start-y" as="xs:integer"/>
							
							<g class="decade-marker">
								<circle cx="{$x}" cy="{$y}" r="1" fill="black"/>
								<text x="{$x}" y="{$y + 5}" text-anchor="middle" fill="black" font-family="$font-family" font-size="4">
									<xsl:value-of select="$start-date + (current() * 10)"/>
								</text>
							</g>
						</xsl:for-each>
					</xsl:if>
					<xsl:apply-templates select="current-group()" mode="svg">
						<xsl:with-param name="start-date" select="$start-date" as="xs:integer" tunnel="yes"/>
						<xsl:with-param name="start-x" select="$start-x" as="xs:integer" tunnel="yes"/>
						<xsl:with-param name="start-y" select="$start-y" as="xs:integer" tunnel="yes"/>
						<xsl:with-param name="increment-x" select="15" as="xs:integer" tunnel="yes"/>
						<xsl:with-param name="font-family" select="$font-family" as="xs:string" tunnel="yes"/>
					</xsl:apply-templates>
				
				</g>
				
				</xsl:for-each-group>
			</svg>

		</xsl:result-document>
		
	</xsl:template>
	
	
	<xsl:template match="event" mode="svg">
		<xsl:param name="start-date" as="xs:integer" tunnel="yes" />
		<xsl:param name="start-x" as="xs:integer" tunnel="yes" />
		<xsl:param name="start-y" as="xs:integer" tunnel="yes" />
		<xsl:param name="increment-x" as="xs:integer" tunnel="yes" />
		<xsl:param name="font-family" as="xs:string" tunnel="yes" />
		
		<xsl:variable name="label-y" select="((position() mod 4) * $increment-x)" as="xs:integer" />
		<xsl:variable name="label-y-offset" select="($start-y - 10) - $label-y" as="xs:integer" />
		
		
		<xsl:variable name="node-x" select="$start-x + xs:integer((date/@year - $start-date) * 12)" as="xs:integer" />
		<xsl:variable name="node-y" select="$start-y" as="xs:integer" />
		<xsl:variable name="label-x" select="$node-x" as="xs:integer" />
		<xsl:variable name="label-y" select="$node-y - $label-y-offset" as="xs:integer" />
				
		<g class="event" xmlns="http://www.w3.org/2000/svg">
			<circle cx="{$node-x}" cy="{$node-y}" r="1" fill="black" fill-opacity="0.6" />
			<path d="M{$node-x} {$node-y} l 0 {0 - $label-y-offset}" stroke="black" stroke-width="0.5" fill="none" stroke-opacity="0.6" />
			<text x="{$label-x + 1}" y="{$label-y + 3}" text-anchor="start" fill="black" font-family="{$font-family}" font-size="4">
                <xsl:value-of select="date/@year"/>
            </text>
			<text x="{$label-x}" y="{$label-y - 1}" text-anchor="middle" fill="black" font-family="{$font-family}" font-size="4">
				
				<xsl:for-each select="person">
					<xsl:sort select="position()" data-type="number" order="descending" />
					<tspan x="{$label-x}" dy="{0 - ((position() - 1) * 5)}">
						<xsl:if test="position() = 1">
							<xsl:value-of select="fn:get-event-glyph(parent::event)" />
							<xsl:text> </xsl:text>
						</xsl:if>
						<xsl:value-of select="fn:get-name(self::*)" /></tspan>
				</xsl:for-each>
			</text>
		</g>
		
	</xsl:template>

	
</xsl:stylesheet>
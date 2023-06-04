<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
	xmlns:math="http://www.w3.org/2005/xpath-functions/math"
	xmlns:fn="http://ns.thecodeyard.co.uk/functions"
	xmlns:map="http://www.w3.org/2005/xpath-functions/map"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	xmlns="http://www.w3.org/2000/svg"
	exclude-result-prefixes="#all"
	expand-text="true"
	version="3.0">
	
	<xsl:output indent="true" />
	
	<xsl:param name="radius-of-core" select="50" as="xs:integer" />
	
	
	<xsl:template match="/*">
		<xsl:variable name="total-generations" select="sort(distinct-values(//person[persona][not(descendant::person/persona)]/count(ancestor-or-self::person)))[position() = last()]" />
		<xsl:variable name="min-chart-radius" select="sum((305, ($total-generations - 5) * 100))" as="xs:integer" />
			
		
		<xsl:variable name="chart-width" select="($min-chart-radius * 2) + 10" />
		<xsl:variable name="chart-height" select="($min-chart-radius * 2) + 10" />	
		
		
		<svg xmlns="http://www.w3.org/2000/svg"
			xmlns:xlink="http://www.w3.org/1999/xlink" 
			width="{$chart-width}" height="{$chart-height}" style="border: 1px solid black;" font-size="12pt">
			
			<xsl:call-template name="draw-generation-group">
				<xsl:with-param name="current-generation" select="/pedigree/person" as="element()*" tunnel="true" />
				<xsl:with-param name="generation-index" select="0" as="xs:integer" tunnel="true" />
				<xsl:with-param name="inner-radius" select="0" as="xs:integer" tunnel="true" />
				<xsl:with-param name="baseline-radius-offset" select="25" as="xs:integer" tunnel="true" />
				<xsl:with-param name="min-outer-radius" select="$radius-of-core" as="xs:integer" tunnel="true" />
				<xsl:with-param name="chart-centre-x" select="xs:integer($chart-width) div 2" as="xs:double" tunnel="true" />
				<xsl:with-param name="chart-centre-y" select="xs:integer($chart-height) div 2" as="xs:double" tunnel="true" />
			</xsl:call-template>	
			
		</svg>
	</xsl:template>

	
	<xsl:template name="draw-generation-group">
		<xsl:param name="current-generation" as="element()*" tunnel="true" />
		<xsl:param name="generation-index" as="xs:integer" tunnel="true" />		
		<xsl:param name="chart-centre-x" as="xs:double" tunnel="true" />
		<xsl:param name="chart-centre-y" as="xs:double" tunnel="true" />
		<xsl:param name="inner-radius" as="xs:integer" tunnel="true" />
		<xsl:param name="min-outer-radius" as="xs:integer" tunnel="true" />
		
		<xsl:variable name="outer-radius" as="xs:integer">
			<xsl:choose>
				<xsl:when test="$generation-index = 3">{$min-outer-radius + 10}</xsl:when>
				<xsl:when test="$generation-index > 5">{$min-outer-radius + 100}</xsl:when>
				<xsl:when test="$generation-index > 3">{$min-outer-radius + 50}</xsl:when>
				<xsl:otherwise>{$min-outer-radius}</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<xsl:variable name="total-segments" select="math:pow(2, $generation-index) ! xs:integer(.)" as="xs:integer" />
		<xsl:variable name="segment-angle" select="360 div $total-segments" as="xs:double" />
		
		<xsl:call-template name="next-generation">
			<xsl:with-param name="generation-index" select="$generation-index + 1" as="xs:integer" tunnel="true" />
			<xsl:with-param name="inner-radius" select="$outer-radius" as="xs:integer" tunnel="true" />
			<xsl:with-param name="min-outer-radius" select="$outer-radius + 25" as="xs:integer" tunnel="true" />
		</xsl:call-template>	
		<g class="generation-{$generation-index}">	
			<circle cx="{$chart-centre-x}" cy="{$chart-centre-y}" r="{$outer-radius}" fill="white" stroke="black" />	
			
			<xsl:if test="$generation-index > 0">
				
				<xsl:for-each select="1 to $total-segments">
					
					<xsl:variable name="segment-index" select="current()" as="xs:integer" />
					<xsl:variable name="end-co-ordinates" select="fn:calculate-point-on-circle($chart-centre-x, $chart-centre-y, current() * $segment-angle, $outer-radius)" as="map(xs:string, xs:decimal)?" />
					
					<xsl:call-template name="draw-divider">
						<xsl:with-param name="start-x" select="$chart-centre-x" as="xs:double" />
						<xsl:with-param name="start-y" select="$chart-centre-y" as="xs:double" />
						<xsl:with-param name="end-x" select="round($end-co-ordinates('x'))" as="xs:double" />
						<xsl:with-param name="end-y" select="round($end-co-ordinates('y'))" as="xs:double" />
						<xsl:with-param name="dashed" select="if ($generation-index = 1 or not(fn:is-even-integer($segment-index))) then true() else false()" as="xs:boolean" />
					</xsl:call-template>
					
				</xsl:for-each>
				
			</xsl:if>		

			<xsl:apply-templates select="$current-generation">
				<xsl:with-param name="generation-index" select="$generation-index" as="xs:integer" tunnel="true" />
				<xsl:with-param name="inner-radius" select="$inner-radius" as="xs:integer" tunnel="true" />
				<xsl:with-param name="outer-radius" select="$outer-radius" as="xs:integer" tunnel="true" />
				<xsl:with-param name="segment-angle" select="$segment-angle" as="xs:double" tunnel="true" />
			</xsl:apply-templates>
			
		</g>
	</xsl:template>
	
	
	<xsl:template name="next-generation">
		<xsl:param name="current-generation" as="element()*" tunnel="true" />
		
		<xsl:variable name="parents" select="$current-generation/parents/person[persona]" as="element()*" />
		<xsl:if test="count($parents) > 0">
			<xsl:call-template name="draw-generation-group">
				<xsl:with-param name="current-generation" select="$parents" as="element()*" tunnel="true" />
			</xsl:call-template>
		</xsl:if>
	</xsl:template>
	
	
	<xsl:template name="draw-divider">
		<xsl:param name="start-x" as="xs:double" />
		<xsl:param name="start-y" as="xs:double" />
		<xsl:param name="end-x" as="xs:double" />
		<xsl:param name="end-y" as="xs:double" />
		<xsl:param name="dashed" select="false()" as="xs:boolean" />
		
		
		<xsl:element name="line">
			<xsl:attribute name="x1">{$start-x}</xsl:attribute>
			<xsl:attribute name="y1">{$start-y}</xsl:attribute>
			<xsl:attribute name="x2">{$end-x}</xsl:attribute>
			<xsl:attribute name="y2">{$end-y}</xsl:attribute>
			<xsl:attribute name="stroke">
				<xsl:choose>
					<xsl:when test="$dashed">grey</xsl:when>
					<xsl:otherwise>black</xsl:otherwise>
				</xsl:choose>				
			</xsl:attribute>
			<xsl:if test="$dashed">
				<xsl:attribute name="stroke-dasharray">3 1</xsl:attribute>
			</xsl:if>
		</xsl:element>		
	</xsl:template>
	
	
	<xsl:template match="person">
		<xsl:param name="generation-index" as="xs:integer" tunnel="true" />
		<xsl:param name="segment-angle" as="xs:double" tunnel="true" />
		
		<xsl:variable name="person-index" select="@position" as="xs:integer" />
		
		<xsl:choose>
			<xsl:when test="$generation-index = 0">
				<xsl:apply-templates select="persona/name/name[@family = 'yes']">
					<xsl:with-param name="person-index" select="$person-index" as="xs:integer" tunnel="true" />
				</xsl:apply-templates>
				<xsl:apply-templates select="persona/name">
					<xsl:with-param name="person-index" select="$person-index" as="xs:integer" tunnel="true" />
					<xsl:with-param name="label" select="string-join(persona/name/name[not(@family = 'yes')], ' ')" as="xs:string" tunnel="true" />	
					<xsl:with-param name="path-id" as="xs:string" tunnel="true">{@id}-text-path-2</xsl:with-param>
					<xsl:with-param name="label-orientation" as="xs:string" tunnel="true">circular</xsl:with-param>
					<xsl:with-param name="font-size" as="xs:double" tunnel="true">1.5</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$generation-index = 3">
				<xsl:apply-templates select="persona/name">
					<xsl:with-param name="person-index" select="$person-index" as="xs:integer" tunnel="true" />
					<xsl:with-param name="baseline-radius-offset" select="30" as="xs:integer" tunnel="true" />
					<xsl:with-param name="label" select="string-join(persona/name/name[@family = 'yes'], ' ')" as="xs:string" tunnel="true" />
					<xsl:with-param name="path-id" as="xs:string" tunnel="true">{@id}-text-path-1</xsl:with-param>
					<xsl:with-param name="font-size" as="xs:double" tunnel="true">0.9</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="persona/name">
					<xsl:with-param name="person-index" select="$person-index" as="xs:integer" tunnel="true" />
					<xsl:with-param name="baseline-radius-offset" select="15" as="xs:integer" tunnel="true" />
					<xsl:with-param name="label" select="string-join((persona/name/name[not(@family = 'yes')])[1], ' ')" as="xs:string" tunnel="true" />					
					<xsl:with-param name="path-id" as="xs:string" tunnel="true">{@id}-text-path-2</xsl:with-param>
					<xsl:with-param name="font-size" as="xs:double" tunnel="true">0.8</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$generation-index > 5">
				<xsl:variable name="label-segment-angle" select="$segment-angle div 2" as="xs:double" />
				<xsl:apply-templates select="persona/name">
					<xsl:with-param name="person-index" select="$person-index" as="xs:integer" tunnel="true" />
					<xsl:with-param name="baseline-radius-offset" select="5" as="xs:integer" tunnel="true" />
					<xsl:with-param name="baseline-angle-offset" select="$label-segment-angle * 1.5" as="xs:double" tunnel="true" />
					<xsl:with-param name="label" select="string-join(((persona/name/name[not(@family = 'yes')])[1], persona/name/name[@family = 'yes']), ' ')" as="xs:string" tunnel="true" />					
					<xsl:with-param name="path-id" as="xs:string" tunnel="true">{@id}-text-path-1</xsl:with-param>
					<xsl:with-param name="label-orientation" as="xs:string" tunnel="true">vertical</xsl:with-param>
					<xsl:with-param name="font-size" as="xs:double" tunnel="true">0.75</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="$generation-index > 3">
				<xsl:variable name="label-segment-angle" select="$segment-angle div 3" as="xs:double" />
				<xsl:apply-templates select="persona/name">
					<xsl:with-param name="person-index" select="$person-index" as="xs:integer" tunnel="true" />
					<xsl:with-param name="baseline-radius-offset" select="5" as="xs:integer" tunnel="true" />
					<xsl:with-param name="baseline-angle-offset" select="$label-segment-angle * 1.25" as="xs:double" tunnel="true" />
					<xsl:with-param name="label" select="string-join((persona/name/name[not(@family = 'yes')])[1], ' ')" as="xs:string" tunnel="true" />					
					<xsl:with-param name="path-id" as="xs:string" tunnel="true">{@id}-text-path-1</xsl:with-param>
					<xsl:with-param name="label-orientation" as="xs:string" tunnel="true">vertical</xsl:with-param>
					<xsl:with-param name="font-size" as="xs:double" tunnel="true">0.85</xsl:with-param>
				</xsl:apply-templates>
				<xsl:apply-templates select="persona/name">					
					<xsl:with-param name="person-index" select="$person-index" as="xs:integer" tunnel="true" />
					<xsl:with-param name="baseline-radius-offset" select="5" as="xs:integer" tunnel="true" />
					<xsl:with-param name="baseline-angle-offset" select="$label-segment-angle * 2.25" as="xs:double" tunnel="true" />
					<xsl:with-param name="label" select="string-join(persona/name/name[@family = 'yes'], ' ')" as="xs:string" tunnel="true" />
					<xsl:with-param name="path-id" as="xs:string" tunnel="true">{@id}-text-path-2</xsl:with-param>
					<xsl:with-param name="label-orientation" as="xs:string" tunnel="true">vertical</xsl:with-param>
					<xsl:with-param name="font-size" as="xs:double" tunnel="true">0.85</xsl:with-param>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates select="persona/name">
					<xsl:with-param name="person-index" select="$person-index" as="xs:integer" tunnel="true" />
					<xsl:with-param name="path-id" as="xs:string" tunnel="true">{@id}-text-path</xsl:with-param>
					<xsl:with-param name="font-size" as="xs:double" tunnel="true">0.9</xsl:with-param>
				</xsl:apply-templates>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	
	<xsl:template match="pedigree/person/persona/name/name[@family = 'yes']">
		<xsl:param name="chart-centre-x" as="xs:double" tunnel="true" />
		<xsl:param name="chart-centre-y" as="xs:double" tunnel="true" />
		
		<text x="{$chart-centre-x}" y="{$chart-centre-y}" font-size="2em" dominant-baseline="mathematical" text-anchor="middle"><xsl:value-of select="." /></text>
	</xsl:template>
	
	
	<xsl:template match="persona/name">
		<xsl:call-template name="draw-label" />
	</xsl:template>
	
	<xsl:template name="draw-label">
		<xsl:param name="chart-centre-x" as="xs:double" tunnel="true" />
		<xsl:param name="chart-centre-y" as="xs:double" tunnel="true" />		
		<xsl:param name="inner-radius" as="xs:integer" tunnel="true" />
		<xsl:param name="outer-radius" as="xs:integer" tunnel="true" />
		<xsl:param name="baseline-radius-offset" select="15" as="xs:integer" tunnel="true" />
		<xsl:param name="generation-index" as="xs:integer" tunnel="true" />
		<xsl:param name="person-index" as="xs:integer" tunnel="true" />
		<xsl:param name="segment-angle" as="xs:double" tunnel="true" />
		<xsl:param name="baseline-angle-offset" select="0" as="xs:double" tunnel="true" />
		<xsl:param name="label" select="string-join(name, ' ')" as="xs:string" tunnel="true" />
		<xsl:param name="path-id" as="xs:string" tunnel="true" />
		<xsl:param name="label-orientation" select="'horizontal'" as="xs:string" tunnel="true" />
		<xsl:param name="font-size" select="1" as="xs:double" tunnel="true" />
		
		
		<xsl:variable name="baseline-radius" select="$outer-radius - $baseline-radius-offset" as="xs:integer" />
		
		<defs>
			<path id="{$path-id}" stroke="pink" fill="none">
				<xsl:attribute name="d">
					<xsl:choose>
						<xsl:when test="$label-orientation = 'circular'">
							<xsl:variable name="start-point" select="fn:calculate-point-on-circle($chart-centre-x, $chart-centre-y, 180, $baseline-radius)" as="map(xs:string, xs:decimal)" />
							<xsl:variable name="mid-point" select="fn:calculate-point-on-circle($chart-centre-x, $chart-centre-y, 0, $baseline-radius)" as="map(xs:string, xs:decimal)" />
							<xsl:variable name="end-point" select="fn:calculate-point-on-circle($chart-centre-x, $chart-centre-y, 180, $baseline-radius)" as="map(xs:string, xs:decimal)" />							
							
							<xsl:text>M {map:get($start-point, 'x')} {map:get($start-point, 'y')} </xsl:text>
							<xsl:text>a {$baseline-radius} {$baseline-radius} 0 0 1 {map:get($mid-point, 'x') - map:get($start-point, 'x')} {map:get($mid-point, 'y') - map:get($start-point, 'y')} </xsl:text> 
							<xsl:text>a {$baseline-radius} {$baseline-radius} 0 0 1 {map:get($end-point, 'x') - map:get($mid-point, 'x')} {map:get($end-point, 'y') - map:get($mid-point, 'y')} </xsl:text>
						</xsl:when>
						<xsl:when test="$label-orientation = 'vertical'">
							<xsl:variable name="start-point" select="fn:calculate-point-on-circle($chart-centre-x, $chart-centre-y, ((($person-index - 1) * $segment-angle)) + $baseline-angle-offset, $inner-radius + $baseline-radius-offset )" as="map(xs:string, xs:decimal)" />
							<xsl:variable name="end-point" select="fn:calculate-point-on-circle($chart-centre-x, $chart-centre-y, ((($person-index - 1) * $segment-angle)) + $baseline-angle-offset, $outer-radius - $baseline-radius-offset)" as="map(xs:string, xs:decimal)" />
							
							<xsl:text>M {map:get($start-point, 'x')} {map:get($start-point, 'y')}</xsl:text>
							<xsl:text>L {map:get($end-point, 'x')} {map:get($end-point, 'y')}</xsl:text>
						</xsl:when>
						<xsl:otherwise>
							<xsl:variable name="start-point" select="fn:calculate-point-on-circle($chart-centre-x, $chart-centre-y, (($person-index - 1) * $segment-angle), $baseline-radius)" as="map(xs:string, xs:decimal)" />
							<xsl:variable name="end-point" select="fn:calculate-point-on-circle($chart-centre-x, $chart-centre-y, ($person-index * $segment-angle), $baseline-radius)" as="map(xs:string, xs:decimal)" />
							
							<xsl:text>M {map:get($start-point, 'x')} {map:get($start-point, 'y')}</xsl:text>
							<xsl:text>a {$baseline-radius} {$baseline-radius} 0 0 1 {map:get($end-point, 'x') - map:get($start-point, 'x')} {map:get($end-point, 'y') - map:get($start-point, 'y')}</xsl:text>
						</xsl:otherwise>
					</xsl:choose>
				</xsl:attribute>
			</path> 			
		</defs>
			 							
		<text font-size="{$font-size}em" text-anchor="middle">
			<textPath startOffset="50%" xlink:href="#{$path-id}"><xsl:value-of select="$label" /></textPath>
		</text>
	</xsl:template>
	
	
	<xsl:function name="fn:calculate-point-on-circle" as="map(xs:string, xs:decimal)">
		<xsl:param name="cx" as="xs:double" />
		<xsl:param name="cy" as="xs:double" />
		<xsl:param name="angle-in-degrees" as="xs:double" />
		<xsl:param name="radius" as="xs:double" />
		
		<xsl:variable name="angle-in-radians" select="($angle-in-degrees - 90) * (math:pi() div 180)" as="xs:double" />
		
		<xsl:map>
			<xsl:map-entry key="'x'">
				<xsl:sequence select="($cx + $radius * math:cos($angle-in-radians)) ! xs:decimal(.)" />
			</xsl:map-entry>
			<xsl:map-entry key="'y'">
				<xsl:sequence select="($cy + $radius * math:sin($angle-in-radians)) ! xs:decimal(.)" />
			</xsl:map-entry> 
		</xsl:map>
	</xsl:function>
	
	
	<xsl:function name="fn:is-even-integer" as="xs:boolean">
		<xsl:param name="integer" as="xs:integer" />
		
		<xsl:sequence select="($integer mod 2) = 0" />
		
	</xsl:function>

	
</xsl:stylesheet>
<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:doc="http://ns.kaikoda.com/documentation/xml"
    xmlns:geo="http://www.w3.org/2003/01/geo/wgs84_pos#" 
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    exclude-result-prefixes="#all" version="2.0">
    
    <doc:doc>
        <doc:title>Maps</doc:title>
        <doc:desc>Inserts markup, style and scripts required to show a map.</doc:desc>
        <doc:notes>
            <doc:note>
                <doc:ul>
                    <doc:ingress>A page containing a map requires:</doc:ingress>
                    <doc:li>
                        <doc:ul>
                            <doc:ingress>HTML head:</doc:ingress>
                            <doc:li>Leaflet CSS</doc:li>
                            <doc:li>Leaflet JS</doc:li>
                        </doc:ul>
                    </doc:li>
                    <doc:li>
                        <doc:ul>
                            <doc:ingress>foot of HTML body:</doc:ingress>
                            <doc:li>Custom map JS</doc:li>
                        </doc:ul>
                    </doc:li>
                </doc:ul>
                <doc:p>A single instance of each per page.</doc:p>
            </doc:note>
            <doc:note>
                <doc:ul>
                    <doc:ingress>Each map requires:</doc:ingress>
                    <doc:li>
                        <doc:ul>
                            <doc:ingress>HTML body:</doc:ingress>
                            <doc:li>an empty element where the map is to be shown, with an ID unique to the map instance ($map-id)</doc:li>
                        </doc:ul>
                    </doc:li>
                    <doc:li>
                        <doc:ul>
                            <doc:ingress>foot of HTML body:</doc:ingress>
                            <doc:li>
                                <doc:p>a JS collection of the data for the markers to be show on the map ($map-location-markers-var-name)</doc:p>
                                <doc:ul>
                                    <doc:ingress>Each location marker requires:</doc:ingress>
                                    <doc:li>latitude</doc:li>
                                    <doc:li>longitude</doc:li>
                                    <doc:li>zoom</doc:li>
                                    <doc:li>label</doc:li>
                                </doc:ul>
                            </doc:li>
                            <doc:li>
                                <doc:ul>
                                    <doc:ingress>a JS call to the map function, passing in</doc:ingress>
                                    <doc:li>$map-id</doc:li>
                                    <doc:li>$map-focus-lat</doc:li>
                                    <doc:li>$map-focus-long</doc:li>
                                    <doc:li>$map-focus-zoom</doc:li>
                                    <doc:li>$map-location-markers-var-name</doc:li>
                                </doc:ul>
                            </doc:li>
                        </doc:ul>
                    </doc:li>
                </doc:ul>
                <doc:p>An instance per map.</doc:p>
            </doc:note>
            <doc:note>
                <doc:p>Used on person profile, location profile, location index.</doc:p>
            </doc:note>
        </doc:notes>
    </doc:doc>
        
        
    
    
    <xsl:template match="view/data" mode="html.footer.scripts" />

    
    
    <doc:doc>
        <doc:title>Map variable names</doc:title>
        <doc:desc>Map ID and markers variable name.</doc:desc>
        <doc:notes>
            <doc:note>
                <doc:p>One of each per map on the page.</doc:p>
            </doc:note>
            <doc:note>
                <doc:p>Called prior to call to map().</doc:p>
            </doc:note>
            <doc:note>
                <doc:p>Used on person profile, location profile.</doc:p>
            </doc:note>
        </doc:notes>
    </doc:doc>
    <xsl:template match="data[entities/location/geo:point or location/geo:point or person/related/location/geo:point] | data/person/related[location]" mode="map locations html.footer.scripts" priority="50">
        <xsl:variable name="id" as="xs:string">
            <xsl:choose>
                <xsl:when test="entities"><xsl:value-of select="concat(entities/*[1]/name(), '-index')" /></xsl:when> 
                <xsl:otherwise><xsl:value-of select="ancestor-or-self::data/*/@id" /></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        
        <xsl:next-match>
            <xsl:with-param name="map-id" select="concat('map-', $id, '-locations')" as="xs:string" tunnel="yes" />
            <xsl:with-param name="map-markers-var-name" select="concat('map', string-join(for $token in tokenize($id, '-') return fn:title-case($token), ''), 'LocationsMarkers')" tunnel="yes" />
        </xsl:next-match>
    </xsl:template>
 
 
    <xsl:template name="insert-map">
        <xsl:param name="locations" as="element()*" tunnel="yes" />
        <xsl:param name="map-id" as="xs:string" tunnel="yes" />
        <xsl:param name="map-markers-var-name" as="xs:string" tunnel="yes" />
        
        <!-- Marker(s) data -->
        <script>
            <xsl:text>var </xsl:text><xsl:value-of select="$map-markers-var-name"/><xsl:text> = [</xsl:text>
            <xsl:for-each select="$locations/geo:point">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@geo:lat" />
                <xsl:text>, </xsl:text>
                <xsl:value-of select="@geo:long" />
                <xsl:text>, '</xsl:text>
                <a href="{$normalised-path-to-view-html}location/{parent::location/@id}{if ($static = 'true') then $ext-html else '/'}"><xsl:value-of select="replace(concat(xs:string(parent::location/name[1]), ' ', key('location', parent::location/within[not(@rel = 'political')][1]/@ref)/xs:string(name[1])), codepoints-to-string(39), '\\''')" /></a>
                <xsl:text>']</xsl:text>
                <xsl:if test="position() != last()">,</xsl:if>
            </xsl:for-each>
            <xsl:text>];</xsl:text>
        </script>
        
        <!-- Map container -->
        <div id="{$map-id}" class="map"><xsl:comment>Leaflet (maps)</xsl:comment></div>
        
    </xsl:template>
    
    
    <doc:doc>
        <doc:title>Custom maps JS</doc:title>
        <doc:desc>For single- and multi-marker maps.</doc:desc>
        <doc:notes>
            <doc:note>
                <doc:p>One per page with a map.</doc:p>
            </doc:note>
            <doc:note>
                <doc:p>Used on location profile, person profile.</doc:p>
            </doc:note>
        </doc:notes>
    </doc:doc>
    <xsl:template match="view/data[entities/location/geo:point or location/geo:point or person/related/location/geo:point]" mode="html.footer.scripts" priority="10">
        <script src="{$normalised-path-to-js}maps.js"><xsl:comment>Leaflet (maps)</xsl:comment></script>
        <xsl:next-match />
    </xsl:template>
    

    
    
    <doc:doc>
        <doc:title>Call to map()</doc:title>
        <doc:desc>For single- and multi-marker map.</doc:desc>
        <doc:notes>
            <doc:note>
                <doc:p>One per map on the page.</doc:p>
            </doc:note>
            <doc:note>
                <doc:p>Depends on map variable names.</doc:p>
            </doc:note>
            <doc:note>
                <doc:p>Used on person profile, location profile.</doc:p>
            </doc:note>
        </doc:notes>
    </doc:doc>
    <xsl:template match="view/data[entities/location/geo:point or location/geo:point or person/related/location/geo:point]" mode="html.footer.scripts" priority="5">
        <xsl:param name="locations" as="element()*" tunnel="yes" />
        <xsl:param name="map-id" as="xs:string" tunnel="yes" />
        <xsl:param name="map-markers-var-name" as="xs:string" tunnel="yes" />
        
        <xsl:variable name="map-focus" select="fn:get-map-focus($locations[geo:point])" as="element()" />
        
        <script>
            <xsl:text>map('</xsl:text><xsl:value-of select="$map-id" /><xsl:text>', </xsl:text>
            <xsl:value-of select="$map-focus/@geo:lat" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$map-focus/@geo:long" />
            <xsl:text>, </xsl:text>
            <xsl:value-of select="$map-focus/@zoom" />
            <xsl:text>,</xsl:text>
            <xsl:value-of select="$map-markers-var-name" />
            <xsl:text>);</xsl:text>
        </script>
        
        <xsl:next-match />
    </xsl:template>
    
    <xsl:template match="view/data" mode="map">		
        <xsl:call-template name="insert-map" />
    </xsl:template>
    
</xsl:stylesheet>
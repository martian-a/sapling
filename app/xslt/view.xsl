<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

	<xsl:import href="home.xsl"/>
	<xsl:import href="entities/location.xsl"/>
	<xsl:import href="entities/person.xsl"/>
	<xsl:import href="entities/name.xsl"/>
	<xsl:import href="entities/event.xsl"/>


	<doc:doc>
		<doc:title>Global contents list.</doc:title>
		<doc:desc>Container.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/views" mode="nav.site">
		<ul>
			<xsl:apply-templates select="index[method/@type = 'html']" mode="nav.site.html"/>
			<xsl:if test="$static = 'false'">
				<xsl:apply-templates select="/app/view[method/@type = 'xml']" mode="nav.site.xml"/>
			</xsl:if>
		</ul>
	</xsl:template>


	<doc:doc>
		<doc:title>Global contents list entry.</doc:title>
		<doc:desc>List item container.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/views/index | /app/view" mode="nav.site.html nav.site.xml" priority="10">
		<li>
			<xsl:next-match/>
		</li>
	</xsl:template>


	<doc:doc>
		<doc:title>Global contents list entry for link to HTML page.</doc:title>
		<doc:desc>Build link and label.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/views/index" mode="nav.site.html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="@path" as="xs:string?"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="self::*" mode="link.html"/>
			</xsl:with-param>
			<xsl:with-param name="is-index" select="true()" as="xs:boolean?"/>
		</xsl:call-template>
	</xsl:template>



	<doc:doc>
		<doc:title>Global contents list for link to XML source.</doc:title>
		<doc:desc>Build link and label.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view" mode="nav.site.xml">
		<xsl:call-template name="href-xml">
			<xsl:with-param name="path" select="@path" as="xs:string?"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="self::*" mode="link.xml"/>
			</xsl:with-param>
			<xsl:with-param name="is-index" select="true()" as="xs:boolean?"/>
		</xsl:call-template>
	</xsl:template>


	<doc:doc>
		<doc:title>Global contents list HTML entry content.</doc:title>
		<doc:desc>Build entry content.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/views/index" mode="link.html">
		<xsl:choose>
			<xsl:when test="title">
				<xsl:value-of select="title"/>
			</xsl:when>
			<xsl:when test="@default = 'true'">
				<xsl:value-of select="/app/name"/>
			</xsl:when>
			<xsl:otherwise>
				<!-- Error: no view title or app name. --> </xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	
	
	<!--
	<doc:doc>
		<doc:title>Page contents list.</doc:title>
		<doc:desc>Heading and containers.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view" mode="nav.page">
		<div class="contents">
			<h2 class="heading">Contents</h2>
			<div class="nav">
				<ul>
					<xsl:apply-templates mode="nav.page"/>
				</ul>
			</div>
		</div>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Page contents list entry.</doc:title>
		<doc:desc>List item container.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view/*" mode="nav.page" priority="100">
		<li>
			<xsl:next-match/>
		</li>
	</xsl:template>
	-->
	
	
	<xsl:template name="href-html">
		<xsl:param name="path" select="/app/views/index[@default = 'true'][1]/@path" as="xs:string?"/>
		<xsl:param name="bookmark" as="xs:string?"/>
		<xsl:param name="params" as="xs:string?"/>
		<xsl:param name="is-index" select="false()" as="xs:boolean?"/> 
		<xsl:param name="content" as="item()*"/>
		<xsl:variable name="url" as="xs:anyURI">
			<xsl:choose>
				<xsl:when test="xs:boolean($static)">
					<xsl:value-of select="
						concat(         
							$normalised-path-to-html,          
							if ($is-index and $path != '/')         
							then concat($path, '/', $index)         
							else if ($path = '/')          
							then $index         
							else $path,          
							$ext-html        
						)"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="
						fn:add-trailing-slash(         
							concat(          
								$normalised-path-to-html,           
								if ($path = '/')           
								then ()           
								else $path         
							)        
						)"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>
		<a href="{$url}{if ($bookmark != '') then concat('#', $bookmark) else ()}{if ($params != '') then concat('?', $params) else ()}">
			<xsl:copy-of select="$content"/>
		</a>
	</xsl:template>



	<xsl:template name="href-xml">
		<xsl:param name="path" select="/app/views/index[@default = 'true'][1]/@path" as="xs:string?"/>
		<xsl:param name="content" as="item()*"/>
		<xsl:param name="is-index" select="false()" as="xs:boolean?"/> 
		<xsl:variable name="url" as="xs:anyURI">
			<xsl:choose>
				<xsl:when test="xs:boolean($static)">
					<xsl:value-of select="        concat(         $normalised-path-to-xml,          if ($path = '/')          then 'index'         else $path,          $ext-xml        )"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="        fn:add-trailing-slash(         concat(          $normalised-path-to-xml,           if ($path = '/')           then ()          else $path         )        )"/>
				</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<a href="{$url}">
			<xsl:copy-of select="$content"/>
		</a>
	</xsl:template>
	
	
	<xsl:template match="*/summary" mode="href-html">
		<xsl:apply-templates/>
	</xsl:template>


</xsl:stylesheet>
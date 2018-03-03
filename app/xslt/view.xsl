<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fn="http://ns.thecodeyard.co.uk/functions" xmlns:doc="http://ns.kaikoda.com/documentation/xml" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="#all" version="2.0">

	<xsl:variable name="ldquo" select="codepoints-to-string(8220)" as="xs:string" />
	<xsl:variable name="rdquo" select="codepoints-to-string(8221)" as="xs:string" />


	<xsl:include href="entities/location.xsl"/>
	<xsl:include href="entities/person.xsl"/>
	<xsl:include href="entities/name.xsl"/>
	<xsl:include href="entities/event.xsl"/>
	<xsl:include href="entities/organisation.xsl"/>
	<xsl:include href="entities/source.xsl"/>
	<xsl:include href="custom/static_content.xsl"/>
	<xsl:include href="custom/note.xsl"/>
	<xsl:include href="custom/timeline.xsl"/>
	<xsl:include href="custom/map.xsl" />
	

	<xsl:template match="/app/view" mode="html.body.title" priority="100">
		<h1>
			<xsl:next-match/>
		</h1>
	</xsl:template>

	<doc:doc>
		<doc:title>Global contents list.</doc:title>
		<doc:desc>Container.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/views" mode="nav.site">
		<ul>
			<xsl:apply-templates select="index[@default = 'true']/sub/*[method/@type = 'html']" mode="nav.site.html"/>
			<xsl:if test="$static = 'false'">
				<xsl:apply-templates select="/app/view[method/@type = 'xml']" mode="nav.site.xml"/>
			</xsl:if>
		</ul>
	</xsl:template>


	<doc:doc>
		<doc:title>Global contents list entry.</doc:title>
		<doc:desc>List item container.</doc:desc>
	</doc:doc>
	<xsl:template match="index | page | view" mode="nav.site.html nav.site.xml" priority="10">
		<li>
			<xsl:next-match/>
		</li>
	</xsl:template>


	<doc:doc>
		<doc:title>Global contents list entry for link to HTML page.</doc:title>
		<doc:desc>Build link and label.</doc:desc>
	</doc:doc>
	<xsl:template match="index | page" mode="nav.site.html">
		<xsl:call-template name="href-html">
			<xsl:with-param name="path" select="@path" as="xs:string?"/>
			<xsl:with-param name="content" as="item()">
				<xsl:apply-templates select="self::*" mode="link.html"/>
			</xsl:with-param>
			<xsl:with-param name="is-index" select="if (name() = 'index') then true() else false()" as="xs:boolean?"/>
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
			<xsl:with-param name="is-index" select="if (name() = 'index') then true() else false()" as="xs:boolean"/>
		</xsl:call-template>
	</xsl:template>




	<doc:doc>
		<doc:title>Global contents list HTML entry content.</doc:title>
		<doc:desc>Build entry content.</doc:desc>
	</doc:doc>
	<xsl:template match="index | page" mode="link.html">
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
		<xsl:param name="path" select="/app/views/*[@default = 'true'][1]/@path" as="xs:string?"/>
		<xsl:param name="bookmark" as="xs:string?"/>
		<xsl:param name="params" as="xs:string?"/>
		<xsl:param name="is-index" select="false()" as="xs:boolean"/> 
		<xsl:param name="content" as="item()*"/>
		<xsl:variable name="url" as="xs:anyURI">
			<xsl:choose>
				<xsl:when test="xs:boolean($static)">
					<xsl:value-of select="
						concat(         
							$normalised-path-to-view-html,          
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
								$normalised-path-to-view-html,           
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
		<xsl:param name="path" select="/app/views/*[@default = 'true'][1]/@path" as="xs:string?"/>
		<xsl:param name="content" as="item()*"/>
		<xsl:param name="is-index" select="false()" as="xs:boolean"/> 
		<xsl:variable name="url" as="xs:anyURI">
			<xsl:choose>
				<xsl:when test="xs:boolean($static)">
					<xsl:value-of select="        concat(         $normalised-path-to-view-xml,          if ($path = '/')          then 'index'         else $path,          $ext-xml        )"/>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="        fn:add-trailing-slash(         concat(          $normalised-path-to-view-xml,           if ($path = '/')           then ()          else $path         )        )"/>
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
	
	
	<doc:doc>
		<doc:desc>Punctuate list of entities</doc:desc>
	</doc:doc>
	<xsl:template name="punctuate-list-href-html">
		<xsl:param name="entries" as="element()*" />
		
		<xsl:for-each select="$entries">
			<xsl:apply-templates select="self::*" mode="href-html" />
			<xsl:choose>
				<xsl:when test="position() = last()" />
				<xsl:when test="position() = (last() - 1)"> and </xsl:when>
				<xsl:otherwise>, </xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>
	</xsl:template>
	
	
	<xsl:template name="generate-jump-navigation">
		<xsl:param name="entries" as="element()*" />
		<xsl:param name="base" select="('A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z')" as="xs:string*" />
		<xsl:param name="id" as="xs:string" />
		
		<xsl:if test="$base != ''">
			<div class="nav nav-list">
				<h3>Jump To</h3>
				<ul>
					<xsl:for-each select="$base">
						<li>
							<xsl:choose>
								<xsl:when test="lower-case(.) = $entries/label/lower-case(.)">
									<a href="#{concat($id, '-', translate(lower-case(.), ' ', '-'))}">
										<xsl:value-of select="."/>
									</a>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="."/>
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</xsl:for-each>
				</ul>
			</div>	
		</xsl:if>
		<div class="multi-column">
			<xsl:for-each select="$entries">
				<div>
					<h3 id="{concat($id, '-', translate(lower-case(label), ' ', '-'))}">
						<xsl:value-of select="label"/>
						<xsl:text> </xsl:text>
						<a href="#{$id}" class="nav" title="Start of index">▴</a>
					</h3>
					<ul>
						<xsl:apply-templates select="entries"/>
					</ul>
				</div>
			</xsl:for-each>
		</div>		
		
	</xsl:template>
	
	<xsl:template name="generate-jump-navigation-group">
		<xsl:param name="group" as="element()*" />
		<xsl:param name="key" as="item()" />
		<xsl:param name="misc-match-test" select="''" as="xs:string?" />
		<xsl:param name="misc-match-label" as="xs:string" />
		
		<group>
			<label>
				<xsl:value-of select="
					if ($key = $misc-match-test) 
					then $misc-match-label
					else $key" />
			</label>
			<entries>
				<xsl:sequence select="$group" />
			</entries>
		</group>
	</xsl:template>
	
	
	<xsl:template match="*[name() = ('person', 'location', 'organisation')][@ref][text()/normalize-space() != '']" priority="100">
		<xsl:next-match>
			<xsl:with-param name="inline-value" select="text()" as="xs:string?" tunnel="yes" />
		</xsl:next-match>	
	</xsl:template>


</xsl:stylesheet>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">

	<xsl:import href="functions.xsl"/>	
	<xsl:import href="defaults.xsl"/>
		
	<xsl:param name="path-to-js" select="'../../js/'" as="xs:string"/>
	<xsl:param name="path-to-css" select="'../../css/'" as="xs:string"/>
	<xsl:param name="path-to-view-xml" select="'../xml'" as="xs:string"/>
	<xsl:param name="path-to-view-html" select="'../html'" as="xs:string"/>
	<xsl:param name="path-to-view-svg" select="'../svg'" as="xs:string"/>
	<xsl:param name="path-to-images" select="'../../images'" as="xs:string"/>
	<xsl:param name="static" select="'false'" as="xs:string"/>

	<xsl:strip-space elements="*"/>
	<xsl:preserve-space elements="p"/>

	<xsl:output method="html" encoding="utf-8" media-type="text/html" indent="yes" omit-xml-declaration="yes" version="5"/>

	<xsl:variable name="normalised-path-to-js" select="if ($path-to-js = '') then '' else fn:add-trailing-slash(translate($path-to-js, '\', '/'))"/>

	<xsl:variable name="normalised-path-to-css" select="if ($path-to-css = '') then '' else fn:add-trailing-slash(translate($path-to-css, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-images" select="if ($path-to-images = '') then '' else fn:add-trailing-slash(translate($path-to-images, '\', '/'))"/>
		
	<xsl:variable name="normalised-path-to-view-xml" select="if ($path-to-view-xml = '') then '' else fn:add-trailing-slash(translate($path-to-view-xml, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-view-html" select="if ($path-to-view-html = '') then '' else fn:add-trailing-slash(translate($path-to-view-html, '\', '/'))"/>
	
	<xsl:variable name="normalised-path-to-view-svg" select="if ($path-to-view-svg = '') then '' else fn:add-trailing-slash(translate($path-to-view-svg, '\', '/'))"/>

	<xsl:variable name="ext-xml" select="if (xs:boolean($static)) then '.xml' else ''" as="xs:string?"/>
	<xsl:variable name="ext-html" select="if (xs:boolean($static)) then '.html' else ''" as="xs:string?"/>
	<xsl:variable name="index" select="if (xs:boolean($static)) then 'index' else ''" as="xs:string?"/>
	
	<xsl:variable name="gender-glyphs" select="('♂', '♀', '⚥', '⚧', '⚪')" as="xs:string*" />
	
	<xsl:include href="view.xsl"/>

	<doc:doc>
		<doc:title>HTML page basics.</doc:title>
	</doc:doc>
	<xsl:template match="/">
		<xsl:apply-templates select="app" mode="html.structure" />
	</xsl:template>	
	
	<xsl:template match="/app" mode="html.structure">
		<html class="{view/@class}" lang="en">
			<head>
				<xsl:apply-templates select="self::*" mode="html.header"/>
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
				<!-- link rel="shortcut icon" href="{$normalised-path-to-images}favicon.ico"/ -->
				<link rel="apple-touch-icon" sizes="180x180" href="/apple-touch-icon.png"/>
				<link rel="icon" type="image/png" sizes="32x32" href="/favicon-32x32.png"/>
				<link rel="icon" type="image/png" sizes="16x16" href="/favicon-16x16.png"/>
				<link rel="manifest" href="/site.webmanifest"/>
				<link rel="mask-icon" href="/safari-pinned-tab.svg" color="#000033"/>
				<meta name="apple-mobile-web-app-title" content="Blue Gum Tree"/>
				<meta name="application-name" content="Blue Gum Tree"/>
				<meta name="msapplication-TileColor" content="#000033"/>
				<meta name="theme-color" content="#000033"/>				
				<xsl:apply-templates select="self::*" mode="html.header.style"/>
				<xsl:apply-templates select="self::*" mode="html.header.scripts"/>
				<xsl:if test="$static = 'true'">
					<script async="async" src="https://www.googletagmanager.com/gtag/js?id=UA-342055-1"><xsl:comment> Google Analytics </xsl:comment></script>
					<script src="{$normalised-path-to-js}analytics.js"><xsl:comment> Google Analytics </xsl:comment></script>
				</xsl:if>
			</head>
			<body class="{if (view/data/entities) then 'index' else 'entity'}">
				<xsl:apply-templates select="self::*" mode="nav.site"/>
				<xsl:apply-templates select="view" mode="html.body"/>
				<xsl:apply-templates select="self::*" mode="html.footer"/>
				<xsl:apply-templates select="self::*" mode="html.footer.scripts"/>
			</body>
		</html>
	</xsl:template>


	<doc:doc>
		<doc:title>HTML header.</doc:title>
		<doc:desc>Page title.</doc:desc>
	</doc:doc>
	<xsl:template match="/app" mode="html.header" priority="100">
		<title>
			<xsl:value-of select="name"/>
			<xsl:variable name="title" as="xs:string?">
				<xsl:apply-templates select="view" mode="view.title"/>
			</xsl:variable>
			<xsl:if test="normalize-space($title) != ''">
				<xsl:text>: </xsl:text>
				<xsl:value-of select="$title"/>
			</xsl:if>
		</title>		
		<xsl:next-match/>
	</xsl:template>
	
	
	<xsl:template match="/app" mode="html.header.style" priority="2000">		
		<link type="text/css" href="{$normalised-path-to-css}global.css" rel="stylesheet"/>
		<link type="text/css" href="{$normalised-path-to-css}project.css" rel="stylesheet"/>
		<xsl:next-match />
	</xsl:template>


	<doc:doc>
		<doc:title>HTML body.</doc:title>
		<doc:desc>Generic content.</doc:desc>
	</doc:doc>
	<xsl:template match="/app/view" mode="html.body" priority="100">
		<div class="main">
			<xsl:apply-templates select="self::*" mode="html.body.title" />
			<xsl:next-match/>
		</div>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Page header.</doc:title>
		<doc:desc>Logo and global contents list.</doc:desc>
	</doc:doc>
	<xsl:template match="/app" mode="nav.site">
		<header class="header">
			<xsl:apply-templates select="assets/image[@role = 'site-logo']" mode="nav.site" />
			<div class="nav nav-site">
				<xsl:apply-templates select="views" mode="nav.site" />
			</div>
		</header>
	</xsl:template>
	
	
	<doc:doc>
		<doc:title>Site Logo.</doc:title>
		<doc:desc>In page header.</doc:desc>
	</doc:doc>
	<xsl:template match="image[@role = 'site-logo']" mode="nav.site">
		<h2 class="logo">
			<xsl:call-template name="href-html">
				<xsl:with-param name="path" select="/app/views/collection[@default = 'true'][1]/@path" as="xs:string" />
				<xsl:with-param name="content" as="item()*">
					<img src="{$normalised-path-to-images}{file[1]/@path}" alt="{title}" />
				</xsl:with-param>
				<xsl:with-param name="is-index" select="true()" as="xs:boolean?" />
			</xsl:call-template>
		</h2>
	</xsl:template>
	
	

	<doc:doc>
		<doc:title>Page footer.</doc:title>
		<doc:desc>Container and copyright statement.</doc:desc>
	</doc:doc>
	<xsl:template match="/app" mode="html.footer">
		<footer id="footer">
			<p class="copyright">Copyright © 2017 Sheila Ellen Thomson</p>
		</footer>	
	</xsl:template>
	
	
	<doc:doc>
		<doc:desc>HTML header and footer scripts: collate and filter locations.</doc:desc>
	</doc:doc>
	<xsl:template match="/app[view/data[entities/location or location or */related/location]]" mode="html.structure" priority="1000">
		<xsl:call-template name="collate-locations" />
	</xsl:template>
	

	<doc:doc>
		<doc:desc>HTML body: collate and filter locations.</doc:desc>
	</doc:doc>
	<!-- xsl:template match="/app/view[data[entities/location or location or */related/location]]" mode="html.body" priority="1000">
		<xsl:call-template name="collate-locations" />
	</xsl:template -->
	
	
	<doc:doc>
		<doc:title>Locations collection</doc:title>
		<doc:desc>Builds the core collection of locations associated with this view.</doc:desc>
		<doc:notes>
			<doc:note>
				<doc:ul>
					<doc:ingress>Used by:</doc:ingress>
					<doc:li>location indexes</doc:li>
					<doc:li>related location lists</doc:li>
					<doc:li>maps</doc:li>
				</doc:ul>
			</doc:note>
		</doc:notes>
		<doc:note>
			<doc:p>Also filters related locations to only those that are either directly referenced from the source or from events related to the source.</doc:p>
			<doc:p>Otherwise the list includes locations that are in the related list purely to provide context for the truly related locations.</doc:p>
		</doc:note>
	</doc:doc>
	<xsl:template name="collate-locations">
		<xsl:variable name="directly-referenced-locations" as="element()*">
			<xsl:for-each select="ancestor-or-self::app/view/data/*[name() != 'location']/related/location">
				<xsl:sequence select="self::*[@id = ancestor::data[1]/*/note/descendant::location/@ref]" />
			</xsl:for-each>
			<xsl:for-each select="ancestor-or-self::app/view/data/name/related/location">
				<xsl:sequence select="self::*[@id = (ancestor::name[1]/derived-from/location/@ref)]" />
			</xsl:for-each>
			<xsl:for-each select="ancestor-or-self::app/view/data/source/related/location">
				<xsl:sequence select="self::*[@id = (ancestor::source[1]/body-matter/descendant::location/@ref, ancestor::source[1]/front-matter/acknowledgements/descendant::location/@ref)]" />
			</xsl:for-each>
			<xsl:for-each select="ancestor-or-self::app/view/data/*[name() = ('organisation', 'event')]/related/location">
				<xsl:sequence select="self::*[@id = ancestor::data[1]/*/location/@ref]" />
			</xsl:for-each>
			<xsl:for-each select="ancestor-or-self::app/view/data/location">
				<xsl:sequence select="self::*" />
			</xsl:for-each>
			<xsl:for-each select="ancestor-or-self::app/view/data/entities/location">
				<xsl:sequence select="self::*" />
			</xsl:for-each>
		</xsl:variable>        
		<xsl:variable name="locations-referenced-from-events" as="element()*">
			<xsl:for-each select="ancestor-or-self::app/view/data/*/related/location">
				<xsl:sequence select="self::*[@id = ancestor::data/*/related/event/descendant::location/@ref]" />
			</xsl:for-each>  
		</xsl:variable>
		
		<xsl:next-match>
			<xsl:with-param name="locations" select="fn:sort-locations($directly-referenced-locations | $locations-referenced-from-events)" as="element()*" tunnel="yes" />
		</xsl:next-match>
	</xsl:template>
	
	
</xsl:stylesheet>
<xsl:stylesheet 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:fn="http://ns.thecodeyard.co.uk/functions" 
	xmlns:doc="http://ns.kaikoda.com/documentation/xml" 
	xmlns:xs="http://www.w3.org/2001/XMLSchema" 
	exclude-result-prefixes="#all" 
	version="2.0">

	<xsl:import href="functions.xsl"/>
	<xsl:import href="defaults.xsl"/>
	<xsl:import href="view.xsl"/>
	
	<xsl:param name="path-to-js" select="'../../js/'" as="xs:string"/>
	<xsl:param name="path-to-css" select="'../../css/'" as="xs:string"/>
	<xsl:param name="path-to-view-xml" select="'../xml'" as="xs:string"/>
	<xsl:param name="path-to-view-html" select="'../html'" as="xs:string"/>
	<xsl:param name="path-to-view-svg" select="'../svg'" as="xs:string"/>
	<xsl:param name="path-to-images" select="'../../images'" as="xs:string"/>
	<xsl:param name="static" select="'false'" as="xs:string"/>

	<xsl:strip-space elements="*"/>

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
	

	<doc:doc>
		<doc:title>HTML page basics.</doc:title>
	</doc:doc>
	<xsl:template match="/">
		<html class="{/app/view/@class}" lang="en">
			<head>
				<xsl:apply-templates mode="html.header"/>
				<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
				<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
				<link rel="shortcut icon" href="{$normalised-path-to-images}favicon.ico" />
				<xsl:apply-templates mode="html.header.scripts"/>
				<link type="text/css" href="{$normalised-path-to-css}global.css" rel="stylesheet"/>
				<xsl:apply-templates mode="html.header.style"/>
			</head>
			<body class="{if (/app/view/data/entities) then 'index' else 'entity'}">
				<xsl:apply-templates mode="nav.site"/>
				<xsl:apply-templates select="app/view" mode="html.body"/>
				<xsl:apply-templates mode="html.footer"/>
                <xsl:apply-templates mode="html.footer.scripts"/>
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
				<xsl:with-param name="path" select="/app/views/index[@default = 'true'][1]/@path" as="xs:string" />
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
	
	
</xsl:stylesheet>
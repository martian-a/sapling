<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="build-static-html"
	type="tcy:build-static-html"
	version="2.0">
	
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:summary>Generates a static, HTML snapshot of the app.</d:summary>
			<d:desc>
				<d:p>Copies across assets that the HTML will rely on (css, javascript) and then converts each of the already generated XML dist files into HTML, directory by directory.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:input port="config" primary="true" />	

	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results" />
	</p:output>
	
	<p:import href="copy_dependencies.xpl" />
	<p:import href="generate_html.xpl" />
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory containing the source data file(s).</d:desc>
			<d:note>
				<d:p>For example: file:///project/build/static/xml/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:variable name="href-app-generic" select="/build/source/app[@role = 'generic']/@href" />
	<p:variable name="href-app-custom" select="/build/source/app[@role = 'custom']/@href" />
	<p:variable name="href-static-generic" select="/build/source/static[@role = 'generic']/@href" />
	<p:variable name="href-static-custom" select="/build/source/static[@role = 'custom']/@href" />
	<p:variable name="href-xml" select="concat(/build/output/site/@href, 'xml/')" />
	<p:variable name="target" select="concat(/build/output/site/@href, 'html/')" />
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Copy javascript and style assets that the result will depend on the output directory.</d:desc>
		</d:doc>
	</p:documentation>
	<tcy:copy-dependencies name="copy-generic-dependencies-from-app">
		<p:with-option name="href" select="$href-app-generic" />
		<p:with-option name="target" select="concat($target, '/assets/')" />
		<p:with-option name="exclude-filter" select="'modules|test|utils|view|xslt'" />
	</tcy:copy-dependencies>
	
	<p:sink />
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Copy javascript and style assets that the result will depend on the output directory.</d:desc>
		</d:doc>
	</p:documentation>
	<tcy:copy-dependencies name="copy-custom-dependencies-from-app">
		<p:with-option name="href" select="$href-app-custom" />
		<p:with-option name="target" select="concat($target, '/assets/')" />
		<p:with-option name="exclude-filter" select="'modules|test|utils|view|xslt'" />
	</tcy:copy-dependencies>
	
	<p:sink />
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Copy miscellaneous assets that the result will depend on the output directory.</d:desc>
		</d:doc>
	</p:documentation>
	<tcy:copy-dependencies name="copy-generic-dependencies-from-static">
		<p:with-option name="href" select="$href-static-generic" />
		<p:with-option name="target" select="concat($target, '/')" />
	</tcy:copy-dependencies>
	
	<p:sink />
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Copy miscellaneous assets that the result will depend on the output directory.</d:desc>
		</d:doc>
	</p:documentation>
	<tcy:copy-dependencies name="copy-custom-dependencies-from-static">
		<p:with-option name="href" select="$href-static-custom" />
		<p:with-option name="target" select="concat($target, '/')" />
	</tcy:copy-dependencies>
	
	<p:sink />
	
	<p:load name="load-stylesheet">
		<p:with-option name="href" select="concat($href-app-generic, 'xslt/global.xsl')" />
	</p:load>
	
	
	<tcy:generate-static-html name="generate-html">
		<p:input port="stylesheet">
			<p:pipe port="result" step="load-stylesheet" />
		</p:input>
		<p:with-option name="href" select="$href-xml" />
		<p:with-option name="target" select="$target" />
		<p:with-option name="path-to-view-html" select="''" />
		<p:with-option name="path-to-view-js" select="''" />
		<p:with-option name="path-to-assets" select="'assets/'" />
	</tcy:generate-static-html>
	

	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of paths to the generated xml files.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:created">
		<p:input port="source">
			<p:pipe port="result" step="copy-generic-dependencies-from-app" />
			<p:pipe port="result" step="copy-custom-dependencies-from-app" />
			<p:pipe port="result" step="copy-generic-dependencies-from-static" />
			<p:pipe port="result" step="copy-custom-dependencies-from-static" />
			<p:pipe port="result" step="generate-html" />
		</p:input>
	</p:wrap-sequence>
	
	<p:add-attribute name="results" attribute-name="step" attribute-value="build-static-html" match="/*" />
	
</p:declare-step>
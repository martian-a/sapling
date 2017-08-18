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
			<d:desc>
				<d:p>Generates a static, HTML snapshot of the app.</d:p>
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
	<p:variable name="href-app" select="/build/source/app/@href" />
	<p:variable name="href-xml" select="concat(/build/output/site/@href, 'xml/')" />
	<p:variable name="target" select="concat(/build/output/site/@href, 'html/')" />
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Copy javascript and style assets that the result will depend on the output directory.</d:desc>
		</d:doc>
	</p:documentation>
	<tcy:copy-dependencies name="copy-dependencies">
		<p:with-option name="href" select="$href-app" />
		<p:with-option name="target" select="concat($target, '/assets/')" />
	</tcy:copy-dependencies>
	
	<p:sink />
	
	<p:load name="load-stylesheet">
		<p:with-option name="href" select="concat($href-app, 'xslt/global.xsl')" />
	</p:load>
	
	
	<tcy:generate-static-html name="generate-html">
		<p:input port="stylesheet">
			<p:pipe port="result" step="load-stylesheet" />
		</p:input>
		<p:with-option name="href" select="$href-xml" />
		<p:with-option name="target" select="$target" />
		<p:with-option name="path-to-html" select="'../html/'" />
		<p:with-option name="path-to-assets" select="'assets/'" />
	</tcy:generate-static-html>
	

	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of paths to the generated xml files.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:created">
		<p:input port="source">
			<p:pipe port="result" step="copy-dependencies" />
			<p:pipe port="result" step="generate-html" />
		</p:input>
	</p:wrap-sequence>
	
	<p:add-attribute name="results" attribute-name="step" attribute-value="build-static-html" match="/*" />
	
</p:declare-step>
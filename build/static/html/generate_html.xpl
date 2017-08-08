<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
	xmlns:c="http://www.w3.org/ns/xproc-step" 
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	version="1.0" 
	type="tcy:generate-static-html"
	name="generate-static-html">
	
	<p:input port="stylesheet" primary="true" />
	<p:option name="href" required="true" />
	<p:option name="target" required="true" />
	<p:option name="path-to-html" required="true" />
	<p:option name="path-to-assets" required="true" />
	
	<p:output port="result" sequence="true" />
	
	<p:directory-list name="directory-listing">
		<p:with-option name="path" select="$href" />
	</p:directory-list>
	
	
	<p:for-each>
		
		<p:iteration-source select="c:directory" />
		
		<p:output port="result" sequence="true" />
		
		<p:group>
			
			<p:output port="result" sequence="true">
				<p:pipe port="result" step="process-files" />
				<p:pipe port="result" step="process-directories" />
			</p:output>
		
			<p:for-each name="process-files">
				
				<p:iteration-source select="c:directory/c:file" />
				
				<p:output port="result" sequence="true" />
				
				<p:group>
					
					<p:variable name="filename" select="c:file/@name" />
					
					<p:load name="load-xml">
						<p:with-option name="href" select="concat($href, $filename)"></p:with-option>
					</p:load>
					
					<p:xslt>
						<p:input port="source">
							<p:pipe port="result" step="load-xml" />
						</p:input>
						<p:input port="stylesheet">
							<p:pipe port="stylesheet" step="generate-static-html" />
						</p:input>		
						<p:with-param name="path-to-js" select="concat($path-to-assets, 'js')" />
						<p:with-param name="path-to-css" select="concat($path-to-assets, 'style')" />
						<p:with-param name="path-to-html" select="$path-to-html" />
						<p:with-param name="path-to-images" select="concat($path-to-assets, 'images')" />
						<p:with-param name="static" select="'true'" />
					</p:xslt>
					
					
					<p:store name="store-html" encoding="utf-8">
						<p:with-option name="href" select="concat($target, substring-before($filename, '.xml'), '.html')"></p:with-option>
					</p:store>
					
					<p:identity>
						<p:input port="source">
							<p:pipe port="result" step="store-html" />
						</p:input>
					</p:identity>
					
				</p:group>
				
			</p:for-each>
			
			<p:sink />
			
			<p:for-each name="process-directories">
				
				<p:iteration-source select="c:directory/c:directory">
					<p:pipe port="result" step="directory-listing" />
				</p:iteration-source>
				
				<p:output port="result" sequence="true" />
				
				<p:group>

					<tcy:generate-static-html>
						
						<p:input port="stylesheet">
							<p:pipe port="stylesheet" step="generate-static-html" />
						</p:input>
						<p:with-option name="href" select="concat($href, c:directory/@name, '/')" />
						<p:with-option name="target" select="concat($target, c:directory/@name, '/')" />
						<p:with-option name="path-to-html" select="concat('../', $path-to-html)" />
						<p:with-option name="path-to-assets" select="concat('../', $path-to-assets)" />
					</tcy:generate-static-html>
					
				</p:group>
				
			</p:for-each>
			
		</p:group>
		
	</p:for-each>
	
</p:declare-step>
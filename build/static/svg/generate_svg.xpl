<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
	xmlns:c="http://www.w3.org/ns/xproc-step" 
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	version="1.0" 
	type="tcy:generate-static-svg"
	name="generate-static-svg">
	
	<p:input port="source" primary="true" />
	<p:input port="stylesheet" />
	
	<p:option name="target" required="true" />
	<p:option name="path-to-view-html" required="true" />
	<p:option name="path-to-assets" required="true" />
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results" />
		<!-- p:pipe port="result" step="generate-svg" / -->
	</p:output>
	
					
	<p:xslt version="2.0" name="generate-dot">
		<p:input port="source">
			<p:pipe port="source" step="generate-static-svg" />
		</p:input>
		<p:input port="stylesheet">
			<p:pipe port="stylesheet" step="generate-static-svg" />
		</p:input>		
		<p:with-param name="path-to-view-html" select="$path-to-view-html" />
		<p:with-param name="path-to-images" select="concat($path-to-assets, 'images')" />
		<p:with-param name="static" select="'true'" />
	</p:xslt>
	
	
	<p:try>
		<p:group>
			
			<p:exec command="dot" name="generate-svg">
				<p:with-option name="args" select="'-Tsvg'" />
				<p:with-option name="source-is-xml" select="'true'" />
				<p:with-option name="method" select="'text'" />
				<p:with-option name="media-type" select="'text'" />
				<p:with-option name="indent" select="'false'" />
				<p:with-option name="omit-xml-declaration" select="'true'" />
				<p:with-option name="encoding" select="'UTF-8'" />
				<p:with-option name="result-is-xml" select="'true'" />
				<p:with-option name="wrap-result-lines" select="'false'"></p:with-option>
				<p:input port="source" sequence="true">
					<p:pipe port="result" step="generate-dot" />
				</p:input>
			</p:exec> 		
	
		</p:group>
		<p:catch name="catch">
			
			<p:identity>
				<p:input port="source" sequence="true">
					<p:pipe port="error" step="catch" />
				</p:input>
			</p:identity>
			
		</p:catch>
	</p:try>
	
	<p:choose>
		<p:when test="/c:result/*">
			
			<p:store name="store-svg" encoding="utf-8">
				<p:input port="source" select="/c:result/*" sequence="true" />
				<p:with-option name="href" select="$target" />
				<p:with-option name="method" select="'xml'" />
				<p:with-option name="media-type" select="'image/svg+xml'" />
				<p:with-option name="indent" select="'true'" />
			</p:store>
			
			<p:identity>
				<p:input port="source" sequence="true">
					<p:pipe port="result" step="store-svg" />
				</p:input>
			</p:identity>
			
		</p:when>
			
		<p:otherwise>
			
			<p:try>
				<p:group>
					
					<p:store name="store-dot" encoding="utf-8">
						<p:input port="source" sequence="true">
							<p:pipe port="result" step="generate-dot" />
						</p:input>
						<p:with-option name="href" select="concat($target, '.error')" />
						<p:with-option name="method" select="'text'" />
						<p:with-option name="media-type" select="'text'" />
						<p:with-option name="indent" select="'false'" />
					</p:store>
					
					<p:identity name="dot-file-href">
						<p:input port="source">
							<p:pipe port="result" step="store-dot" />
						</p:input>
					</p:identity>
					
					<p:sink />
					
					<p:identity>
						<p:input port="source">
							<p:inline><c:error>Error generating SVG</c:error></p:inline>
						</p:input>
					</p:identity>
					
					<p:add-attribute attribute-name="stdin" match="/*">
						<p:with-option name="attribute-value" select="/*">
							<p:pipe port="result" step="dot-file-href" />
						</p:with-option>
					</p:add-attribute>
					
				</p:group>
				<p:catch>
					
					<p:identity name="generate-error">
						<p:input port="source">
							<p:inline><c:error>Error generating DOT</c:error></p:inline>
						</p:input>
					</p:identity>
					
					<p:store name="store-dot" encoding="utf-8">
						<p:with-option name="href" select="concat($target, '.error')" />
						<p:with-option name="method" select="'text'" />
						<p:with-option name="media-type" select="'text'" />
						<p:with-option name="indent" select="'false'" />
					</p:store>
					
					<p:add-attribute attribute-name="target" match="*">
						<p:input port="source">
							<p:pipe port="result" step="generate-error" />
						</p:input>
						<p:with-option name="attribute-value" select="$target" />
					</p:add-attribute>
					
				</p:catch>
			</p:try>
			
		</p:otherwise>	

	</p:choose>
			
	<p:add-attribute name="results" attribute-name="step" attribute-value="generate-static-svg" match="/*" />
	
</p:declare-step>
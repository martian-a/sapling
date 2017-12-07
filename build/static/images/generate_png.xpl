<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
	xmlns:c="http://www.w3.org/ns/xproc-step" 
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	version="1.0" 
	type="tcy:generate-static-png"
	name="generate-static-png">
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Uses GraphViz (on local file system) to convert a graph represented in DOT into a PNG image.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:input port="source" primary="true" />
	
	<p:option name="target" required="true" />
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results" />
	</p:output>
	
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	
	<p:try>
		<p:group>
			
			<p:variable name="target-directory" select="string-join(tokenize($target, '/')[position() != last()], '/')" />
			
			<cxf:mkdir>
				<p:with-option name="href" select="$target-directory" />
			</cxf:mkdir>
			
			<p:exec command="dot" name="generate-png" arg-separator="!">
				<p:input port="source">
					<p:pipe port="source" step="generate-static-png" />
				</p:input>
				<p:with-option name="args" select="concat('-Tpng!-o', $target)" />
				<p:with-option name="source-is-xml" select="'true'" />
				<p:with-option name="method" select="'text'" />
				<p:with-option name="media-type" select="'text/vnd.graphviz'" />
				<p:with-option name="indent" select="'false'" />
				<p:with-option name="omit-xml-declaration" select="'true'" />
				<p:with-option name="encoding" select="'UTF-8'" />
				<p:with-option name="result-is-xml" select="'false'" />
				<p:with-option name="wrap-result-lines" select="'true'" />
				<p:with-option name="errors-is-xml" select="'false'" />
				<p:with-option name="wrap-error-lines" select="'true'" />
			</p:exec> 		
			
			<p:add-attribute attribute-name="target" match="*">
				<p:input port="source">
					<p:inline><c:result /></p:inline>
				</p:input>
				<p:with-option name="attribute-value" select="$target" />
			</p:add-attribute>

		</p:group>
		<p:catch name="catch">
			
			<p:identity>
				<p:input port="source">
					<p:pipe port="error" step="catch" />
				</p:input>
			</p:identity>
			
		</p:catch>
	</p:try>
	
	<!--
	<p:choose>
		<p:when test="/c:result/*">
			
			<p:store name="store-png" encoding="utf-8">
				<p:input port="source" select="/c:result/*" />
				<p:with-option name="href" select="$target" />
				<p:with-option name="method" select="'xml'" />
				<p:with-option name="media-type" select="'image/png'" />
				<p:with-option name="indent" select="'true'" />
			</p:store>
			
			<p:identity>
				<p:input port="source">
					<p:pipe port="result" step="store-png" />
				</p:input>
			</p:identity>
			
		</p:when>
			
		<p:otherwise>
			
			<p:try>
				<p:group>
					
					<p:store name="store-dot" encoding="utf-8">
						<p:input port="source">
							<p:pipe port="source" step="generate-static-png" />
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
							<p:inline><c:error>Error generating PNG</c:error></p:inline>
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
	-->
	
	<p:add-attribute name="results" attribute-name="step" attribute-value="generate-static-png" match="/*" />
	
</p:declare-step>
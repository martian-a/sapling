<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
	xmlns:c="http://www.w3.org/ns/xproc-step" 
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	version="1.0" 
	type="tcy:generate-family-tree"
	name="generate-family-tree">
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Generates a graph of the immediate family for each person in the core distribution data.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:option name="id" required="true" />
	<p:option name="href-app" required="true" />
	<p:option name="path-to-view-html" required="true" />
	<p:option name="path-to-assets" required="true" />
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results-errors" />
		<p:pipe port="result" step="results-created" />
	</p:output>
	
	<p:import href="../../utils/xquery/get_app_view.xpl" />
	<p:import href="generate_svg.xpl" />
	<p:import href="generate_png.xpl" />
	
	<p:variable name="target" select="concat($path-to-assets, 'images/family-tree/')" />
			
	<tcy:get-app-view name="generate-xml">
		<p:with-option name="path" select="'person'" />
		<p:with-option name="id" select="$id" />
		<p:with-option name="for-graph" select="true()" />
	</tcy:get-app-view>
		
	<p:choose name="generate-images">
		
		<p:when test="/app/view/data/person[@id = $id]/related[event/@type = ('birth', 'christening', 'marriage')]">
			
			<p:output port="result" sequence="true">
				<p:pipe port="result" step="orientation" />
			</p:output>
			
			<p:load name="stylesheet">
				<p:with-option name="href" select="concat($href-app, 'xslt/visualisations/family_tree.xsl')" />
			</p:load>
			
			<p:sink />
			
			<p:for-each name="orientation">
				
				<p:iteration-source select="/options/option">
					<p:inline>
						<options>
							<option>TD</option>
							<option>LR</option>
						</options>
					</p:inline>
				</p:iteration-source>

				<p:output port="result" sequence="true">
					<p:pipe port="result" step="generate-images-in-orientation" />
				</p:output>

				<p:group name="generate-images-in-orientation">
					
					<p:output port="result" sequence="true">
						<p:pipe port="result" step="generate-svg" />
						<p:pipe port="result" step="generate-png" />
					</p:output>
					
					<p:variable name="graph-direction" select="/option" />
					<p:variable name="orientation" select="if ($graph-direction = 'LR') then 'portrait' else 'landscape'" />
					
					<p:xslt version="2.0" name="generate-dot">
						<p:input port="source">
							<p:pipe port="result" step="generate-xml" />
						</p:input>
						<p:input port="stylesheet">
							<p:pipe port="result" step="stylesheet" />
						</p:input>		
						<p:with-param name="path-to-view-html" select="$path-to-view-html" />
						<p:with-param name="path-to-images" select="concat($path-to-assets, 'images/')" />
						<p:with-param name="static" select="'true'" />
						<p:with-param name="serialise" select="'dot'" />
						<p:with-param name="graph-direction" select="$graph-direction" />
					</p:xslt>
					
					<p:sink />
					
					<tcy:generate-static-svg name="generate-svg">
						<p:input port="source">
							<p:pipe port="result" step="generate-dot" />
						</p:input>
						<p:with-option name="target" select="concat($target, 'svg/person/', $orientation, '/', $id, '.svg')" />
					</tcy:generate-static-svg>
					
					<p:sink />
					
					<tcy:generate-static-png name="generate-png">
						<p:input port="source">
							<p:pipe port="result" step="generate-dot" />
						</p:input>
						<p:with-option name="target" select="concat(substring-after($target, 'file://'), 'png/person/', $orientation, '/', $id, '.png')" />
					</tcy:generate-static-png>
					
					<p:sink />
					
				</p:group>
				
				
			</p:for-each>
			
		</p:when>
		
		<p:otherwise>
			
			<p:output port="result">
				<p:pipe port="result" step="log" />
			</p:output>
			
			<p:identity>
				<p:input port="source">
					<p:inline>
						<c:result>Subject has no recorded family.</c:result>
					</p:inline>
				</p:input>
			</p:identity>
			
			<p:add-attribute name="log" attribute-name="person" match="/*">
				<p:with-option name="attribute-value" select="$id" />
			</p:add-attribute>
			
		</p:otherwise>
		
	</p:choose>

	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of paths to the generated SVG files.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:created">
		<p:input port="source" select="/c:result">
			<p:pipe port="result" step="generate-images" />
		</p:input>
	</p:wrap-sequence>
	
	<p:add-attribute name="results-created" attribute-name="step" attribute-value="generate-family-tree" match="/*" />
	
	<p:sink />
	
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of errors generated during the SVG generation process.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:errors">
		<p:input port="source" select="/c:error">
			<p:pipe port="result" step="generate-images" />
		</p:input>
	</p:wrap-sequence>
	
	<p:add-attribute name="results-errors" attribute-name="step" attribute-value="generate-family-tree" match="/*" />
	
	<p:sink />
	
</p:declare-step>
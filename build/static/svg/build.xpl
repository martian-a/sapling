<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="build-static-svg"
	type="tcy:build-static-svg"
	version="2.0">
	
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Generates static SVG network visualisations for the immediate family of every person in the core distribution data.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:input port="config" primary="true" />	
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results-errors" />
		<p:pipe port="result" step="results-created" />
	</p:output>
	
	<p:import href="../../utils/xquery/generate_config.xpl" />
	<p:import href="../../utils/xquery/get_entity_list.xpl" />
	<p:import href="../../utils/xquery/get_app_view.xpl" />
	<p:import href="generate_svg.xpl" />
	
	
	<p:variable name="href-app" select="/build/source/app/@href" />
	<p:variable name="target" select="concat(/build/output/site/@href, 'html/assets/images/network-graphs/svg/person/')" />
	
	
	<tcy:generate-xquery-config>
		<p:input port="config">
			<p:pipe port="config" step="build-static-svg" />
		</p:input>
		<p:with-option name="role" select="'core'"></p:with-option>
	</tcy:generate-xquery-config>
	
	<p:sink />
	
	<p:load name="load-stylesheet">
		<p:with-option name="href" select="concat($href-app, 'xslt/visualisations/family_tree.xsl')" />
	</p:load>
	
	<p:sink />
	
	<tcy:query-get-entity-list name="entity-list">
		<p:with-option name="path" select="'person'" />
	</tcy:query-get-entity-list>

	
	<p:for-each name="generate-svg-per-person">
		
		<p:iteration-source select="/*/*[@id]" />
		
		<p:output port="result" sequence="true" />
			
		
		<p:group>
			
			<p:variable name="id" select="*/@id" />
			
			<tcy:get-app-view name="generate-xml">
				<p:with-option name="path" select="'person'" />
				<p:with-option name="id" select="$id" />
				<p:with-option name="for-graph" select="true()" />
			</tcy:get-app-view>
			
			<p:sink />
			
			<p:choose>
			
				<p:when test="/app/view/data/person[@id = $id]/related[event/@type = ('birth', 'christening', 'marriage')]">
					
					<p:output port="result" sequence="true">
						<p:pipe port="result" step="generate-svg-portrait" />
						<p:pipe port="result" step="generate-svg-landscape" />
					</p:output>
					
					<p:xpath-context>
						<p:pipe port="result" step="generate-xml" />
					</p:xpath-context>
					
					<tcy:generate-static-svg name="generate-svg-portrait">
						<p:input port="source">
							<p:pipe port="result" step="generate-xml" />
						</p:input>
						<p:input port="stylesheet">
							<p:pipe port="result" step="load-stylesheet" />
						</p:input>
						<p:with-option name="target" select="concat($target, 'portrait/', $id, '.svg')" />
						<p:with-option name="path-to-view-html" select="'../../../../../../html/'" />
						<p:with-option name="path-to-assets" select="'../../../../../../html/assets/'" />
						<p:with-option name="graph-direction" select="'LR'" />
					</tcy:generate-static-svg>
					
					<tcy:generate-static-svg name="generate-svg-landscape">
						<p:input port="source">
							<p:pipe port="result" step="generate-xml" />
						</p:input>
						<p:input port="stylesheet">
							<p:pipe port="result" step="load-stylesheet" />
						</p:input>
						<p:with-option name="target" select="concat($target, 'landscape/', $id, '.svg')" />
						<p:with-option name="path-to-view-html" select="'../../../../../../html/'" />
						<p:with-option name="path-to-assets" select="'../../../../../../html/assets/'" />
						<p:with-option name="graph-direction" select="'TD'" />
					</tcy:generate-static-svg>
					
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
			
		</p:group>
		
	</p:for-each>
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of paths to the generated SVG files.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:created">
		<p:input port="source" select="/c:result" sequence="true">
			<p:pipe port="result" step="generate-svg-per-person" />
		</p:input>
	</p:wrap-sequence>

	<p:add-attribute name="results-created" attribute-name="step" attribute-value="build-static-svg" match="/*" />

	<p:sink />
	
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of errors generated during the SVG generation process.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:errors">
		<p:input port="source" select="/c:error" sequence="true">
			<p:pipe port="result" step="generate-svg-per-person" />
		</p:input>
	</p:wrap-sequence>
		
	<p:add-attribute name="results-errors" attribute-name="step" attribute-value="build-static-svg" match="/*" />
	
	<p:sink />
	
</p:declare-step>
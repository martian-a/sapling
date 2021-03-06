<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="build-static-xml"
	type="tcy:build-static-xml"
	version="2.0">
	
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Creates a custom XML file from which a static site index view will be generated.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:input port="config" primary="true" />
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results" />
	</p:output>
	
	
	<p:import href="../../utils/xquery/generate_config.xpl" />
	<p:import href="../../utils/xquery/get_views.xpl" />
	<p:import href="generate_app_view.xpl" />
	<p:import href="../../utils/xquery/get_entity_list.xpl" />
	
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory containing the source data file(s).</d:desc>
			<d:note>
				<d:p>For example: file:///project/build/static/xml/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:variable name="data-collection-href" select="/build/output/data[@role = 'core']/@href" />
	<p:variable name="target" select="concat(/build/output/site/@href, 'xml/')" />
	
	
	<tcy:generate-xquery-config>
		<p:input port="config">
			<p:pipe port="config" step="build-static-xml" />
		</p:input>
		<p:with-option name="role" select="'core'"></p:with-option>
	</tcy:generate-xquery-config>
	
	<p:sink />
	
	<tcy:query-get-views name="app-views"/>

	<p:identity>
		<p:input port="source">
			<p:pipe port="result" step="app-views" />
		</p:input>
		<p:log port="result" href="app-views.log" />
	</p:identity>
	
	<p:sink />

	<p:for-each name="generate-xml">
		
		<p:iteration-source select="/views/descendant::collection">
			<p:pipe port="result" step="app-views" />
		</p:iteration-source>
		
		<p:output port="result" sequence="true">
			<p:pipe port="result" step="generate-views" />
		</p:output>
		
		<p:group name="generate-views">
			
			<p:output port="result" sequence="true">
				<p:pipe port="result" step="index-view" />
				<p:pipe port="result" step="entity-views" />
				<p:pipe port="result" step="page-views" />
			</p:output>
						
			<p:variable name="path" select="/collection/@path" />
			<p:variable name="href" select="concat($target, if ($path = '/') then '' else concat(string-join(/collection/ancestor-or-self::collection/@path, '/'), '/'))" />
			
			<p:identity>
				<p:input port="source">
					<p:pipe port="current" step="generate-xml" />
				</p:input>
				<p:log port="result" href="generate-xml.log" />
			</p:identity>
			
			<p:for-each name="index-view">						
				
				<p:iteration-source select="/collection[@index = 'true']">
					<p:pipe port="current" step="generate-xml" />
				</p:iteration-source>
				
				<p:output port="result" sequence="false" />
					
				<p:group>
					
					<p:identity>
						<p:input port="source">
							<p:pipe port="current" step="index-view" />
						</p:input>
						<p:log port="result" href="index-view.log" />
					</p:identity>
					
					<tcy:generate-app-view >
						
						<p:with-option name="target" select="concat($href, 'index.xml')" />
						<p:with-option name="path" select="$path" />
						<p:with-option name="id" select="''" />
						
					</tcy:generate-app-view>
					
				</p:group>
				
			</p:for-each>

			<p:sink />
			
			
			<p:for-each name="entity-views">
				
				<p:iteration-source select="/collection[@entities = 'true']">
					<p:pipe port="current" step="generate-xml" />
				</p:iteration-source>
				
				<p:output port="result" sequence="true" />
					
				<p:group>	
					
					<tcy:query-get-entity-list>
						<p:with-option name="path" select="$path" />
					</tcy:query-get-entity-list>
					
					<p:for-each>
						
						<p:iteration-source select="/*/*[@id]" />
						
						<p:output port="result" sequence="true" />
						
						<p:group>
							
							<p:variable name="id" select="*/@id" />
							
							<tcy:generate-app-view>
								
								<p:with-option name="target" select="concat($href, encode-for-uri($id), '.xml')" />
								<p:with-option name="path" select="$path" />
								<p:with-option name="id" select="$id" />
								
							</tcy:generate-app-view>
							
						</p:group>
						
					</p:for-each>		
					
				</p:group>

			</p:for-each>
			
			
			<p:sink />
			
			
			<p:for-each name="page-views">
				
				<p:iteration-source select="/collection/sub/page">
					<p:pipe port="current" step="generate-xml" />
				</p:iteration-source>
				
				<p:output port="result" sequence="true" />
				
				<p:group>
					
					<p:variable name="path" select="/page/@path" />
					
					<tcy:generate-app-view>
						
						<p:with-option name="target" select="concat($href, encode-for-uri($path), '.xml')" />
						<p:with-option name="path" select="$path" />
						<p:with-option name="id" select="''" />
						
					</tcy:generate-app-view>
					
				</p:group>
				
			</p:for-each>
			
		</p:group>
		
	</p:for-each>
		
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of paths to the generated xml files.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:created">
		<p:input port="source">
			<p:pipe port="result" step="generate-xml" />
		</p:input>
	</p:wrap-sequence>
	
	<p:add-attribute name="results" attribute-name="step" attribute-value="build-static-xml" match="/*" />
	
</p:declare-step>
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
	
	<p:import href="get_index_list.xpl" />
	<p:import href="generate_app_view.xpl" />
	<p:import href="get_entity_list.xpl" />
	<p:import href="../../utils/generate_xquery_config.xpl" />
	
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory containing the source data file(s).</d:desc>
			<d:note>
				<d:p>For example: file:///project/build/static/xml/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:variable name="data-collection-href" select="/build/output/data/@href" />
	<p:variable name="target" select="concat(/build/output/site/@href, 'xml/')" />
	
	
	<tcy:generate-xquery-config>
		<p:input port="config">
			<p:pipe port="config" step="build-static-xml" />
		</p:input>
		<p:with-option name="target" select="substring-after(resolve-uri('.'), ':')"></p:with-option>
	</tcy:generate-xquery-config>
		
	<p:sink />
	
	<tcy:query-get-index-list name="index-list"/>
	
	<p:for-each name="generate-xml">
		
		<p:iteration-source select="/*/index">
			<p:pipe port="result" step="index-list" />
		</p:iteration-source>
		
		<p:output port="result" sequence="true">
			<p:pipe port="result" step="generate-views" />
		</p:output>
		
		<p:group name="generate-views">
			
			<p:output port="result" sequence="true">
				<p:pipe port="result" step="index-view" />
				<p:pipe port="result" step="entity-views" />
			</p:output>
						
			<p:variable name="path" select="*/@path" />
			<p:variable name="href" select="concat($target, if ($path = '/') then '' else concat($path, '/'))" />
			
			<tcy:generate-app-view name="index-view">
				
				<p:with-option name="target" select="concat($href, 'index.xml')" />
				<p:with-option name="path" select="$path" />
				<p:with-option name="id" select="''" />
				
			</tcy:generate-app-view>
			
			
			<tcy:query-get-entity-list>
				<p:with-option name="path" select="$path" />
			</tcy:query-get-entity-list>
			
			
			<p:for-each name="entity-views">
				
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
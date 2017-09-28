<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="build-static-images"
	type="tcy:build-static-images"
	version="2.0">
	
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Generates network visualisations for the immediate family of every person in the core distribution data.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:input port="config" primary="true" />	
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results" />
	</p:output>
	
	<p:import href="../../utils/xquery/generate_config.xpl" />
	<p:import href="../../utils/xquery/get_entity_list.xpl" />
	<p:import href="generate_family_tree.xpl" />
	<p:import href="generate_timeline.xpl" />

	<p:variable name="href-app" select="/build/source/app/@href" />
	<p:variable name="path-to-view-html" select="concat(/build/output/site/@href, 'html/')" />
	<p:variable name="path-to-assets" select="concat($path-to-view-html, 'assets/')"  />

	<tcy:generate-xquery-config>
		<p:input port="config">
			<p:pipe port="config" step="build-static-images" />
		</p:input>
		<p:with-option name="role" select="'core'"></p:with-option>
	</tcy:generate-xquery-config>
	
	<p:sink />
	
	<tcy:query-get-entity-list name="entity-list">
		<p:with-option name="path" select="'person'" />
	</tcy:query-get-entity-list>
	
	<p:for-each name="generate-images-per-person">
		
		<p:iteration-source select="/*/*[@id]" />
		
		<p:output port="result" sequence="true" />
		
		<p:group>
			
			<p:variable name="id" select="*/@id" />

			<tcy:generate-family-tree name="generate-family-tree">
				<p:with-option name="id" select="$id" />
				<p:with-option name="href-app" select="$href-app" />
				<p:with-option name="path-to-view-html" select="$path-to-view-html" />
				<p:with-option name="path-to-assets" select="$path-to-assets" />
			</tcy:generate-family-tree>
			
			<p:sink />
			
			<tcy:generate-timeline name="generate-timeline">
				<p:with-option name="id" select="$id" />
				<p:with-option name="href-app" select="$href-app" />
				<p:with-option name="path-to-view-html" select="$path-to-view-html" />
				<p:with-option name="path-to-assets" select="$path-to-assets" />
			</tcy:generate-timeline>
			
		</p:group>
		
	</p:for-each>
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of paths to the generated xml files.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:results">
		<p:input port="source">
			<p:pipe port="result" step="generate-images-per-person" />
		</p:input>
	</p:wrap-sequence>
	
	<p:add-attribute name="results" attribute-name="step" attribute-value="build-static-images" match="/*" />
	
	
</p:declare-step>
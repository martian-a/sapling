<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step 
	xmlns:c="http://www.w3.org/ns/xproc-step" 
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	version="1.0" 
	type="tcy:generate-timeline"
	name="generate-timeline">
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Generates a graph of events related to the subject (person).</d:p>
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
	
	<p:variable name="target" select="concat($path-to-assets, 'images/timeline/')" />
			
	<tcy:get-app-view name="generate-xml">
		<p:with-option name="path" select="'person'" />
		<p:with-option name="id" select="$id" />
		<p:with-option name="for-graph" select="false()" />
	</tcy:get-app-view>
	
	<p:choose name="generate-images">
		
		<p:when test="/app/view/data/person[@id = $id]/related[event/date/@year]">
			
			<p:output port="result" sequence="true">
				<p:pipe port="result" step="store-svg" />
			</p:output>
			
			<p:load name="stylesheet">
				<p:with-option name="href" select="concat($href-app, 'xslt/visualisations/timeline.xsl')" />
			</p:load>
			
			<p:sink />
					
			<p:xslt version="2.0" name="generate-svg">
				<p:input port="source">
					<p:pipe port="result" step="generate-xml" />
				</p:input>
				<p:input port="stylesheet">
					<p:pipe port="result" step="stylesheet" />
				</p:input>		
				<p:with-param name="path-to-view-html" select="$path-to-view-html" />
				<p:with-param name="path-to-images" select="concat($path-to-assets, 'images/')" />
				<p:with-param name="static" select="'true'" />
			</p:xslt>
			
			<p:store name="store-svg" encoding="utf-8" indent="false" media-type="image/svg+xml" method="xml">
				<p:with-option name="href" select="concat($target, '/person/', $id, '.svg')" />
			</p:store>
					
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
	
	<p:add-attribute name="results-created" attribute-name="step" attribute-value="generate-timeline" match="/*" />
	
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
	
	<p:add-attribute name="results-errors" attribute-name="step" attribute-value="generate-timeline" match="/*" />
	
	<p:sink />
	
</p:declare-step>
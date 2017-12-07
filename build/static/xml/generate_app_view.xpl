<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	type="tcy:generate-app-view"
	version="2.0">
	
	<p:option name="target" required="true" />
	<p:option name="path" required="true" />
	<p:option name="id" required="true" />
	<p:option name="for-graph" select="false()" />
	
	<p:output port="result" sequence="true" />
	
	<p:import href="../../utils/xquery/get_app_view.xpl" />
	
	<p:group>
		
		<p:output port="result" sequence="true">
			<p:pipe port="result" step="store" />
		</p:output>
		
		<tcy:get-app-view name="generate-xml">
			<p:with-option name="path" select="$path" />
			<p:with-option name="id" select="$id" />
			<p:with-option name="for-graph" select="$for-graph" />
		</tcy:get-app-view>
		
		<p:xslt name="add-schema-refs">
			<p:input port="stylesheet">
				<p:document href="../../utils/associate_schemas.xsl" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
		</p:xslt>
		
		<p:documentation>
			<d:doc scope="step">
				<d:desc>Store the index data.</d:desc>
			</d:doc>
		</p:documentation>
		<p:store name="store"
			method="xml"
			encoding="utf-8"
			media-type="text/xml"
			indent="true" 
			omit-xml-declaration="false"
			version="1.0">
			<p:with-option name="href" select="$target" />
		</p:store>
		
	</p:group>
	
</p:declare-step>
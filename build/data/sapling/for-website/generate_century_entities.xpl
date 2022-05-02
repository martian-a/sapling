<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	type="tcy:generate-century-entities"
	name="generate-century-entities"
	version="2.0">
	
	<p:input port="config" primary="true" />
	
	<p:option name="target" required="true" />
	
	<p:output port="result" sequence="true" />
	
	<p:option name="role" select="'core'" />
	
	
	<p:import href="../utils/xquery/generate_config.xpl" />
	
	<tcy:generate-xquery-config>
		<p:input port="config">
			<p:pipe port="config" step="generate-century-entities" />
		</p:input>
		<p:with-option name="role" select="$role" />
	</tcy:generate-xquery-config>
	
	<p:sink />
	
	<p:group>
		
		<p:output port="result" sequence="true">
			<p:pipe port="result" step="store" />
		</p:output>	
		
		<p:xquery name="get-events">
			<p:input port="source">
				<p:inline><app /></p:inline>
			</p:input>
			<p:input port="query">
				<p:inline>
					<c:query>
						<![CDATA[
								xquery version "3.0";
								declare namespace c="http://www.w3.org/ns/xproc-step";
								declare namespace xs="http://www.w3.org/2001/XMLSchema";
								
								import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "../utils/xquery/config.xq";
								import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "../../app/modules/data.xq";
								
								<app>
									<data>
										<events>{data:get-entities('event')}</events>
									</data>
								</app>
						]]>
					</c:query>
				</p:inline>		
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
		</p:xquery>


		<p:xslt>
			<p:input port="stylesheet">
				<p:document href="generate_century_entities.xsl" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
		</p:xslt>
		
		
		<p:xslt name="add-schema-refs">
			<p:input port="stylesheet">
				<p:document href="../utils/associate_schemas.xsl" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
		</p:xslt>


		<p:documentation>
			<d:doc scope="step">
				<d:desc>Store the entity data.</d:desc>
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
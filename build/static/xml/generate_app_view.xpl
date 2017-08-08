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
	
	<p:output port="result" sequence="true" />
	
	<p:group>
		
		<p:output port="result" sequence="true">
			<p:pipe port="result" step="store" />
		</p:output>
		
		<p:xquery name="generate-xml">
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
								
								import module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config" at "config.xq";
								import module namespace data = "http://ns.thecodeyard.co.uk/xquery/modules/data" at "../../../app/modules/data.xq";
								
								declare variable $path as xs:string external;
								declare variable $id as xs:string external;
								
								data:view-app-xml($path, $id)
							]]>
					</c:query>
				</p:inline>		
			</p:input>
			<p:with-param name="path" select="$path" />
			<p:with-param name="id" select="$id" />
		</p:xquery>
		
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
			<p:input port="source">
				<p:pipe port="result" step="generate-xml" />
			</p:input>
			<p:with-option name="href" select="$target" />
		</p:store>
		
	</p:group>
	
</p:declare-step>
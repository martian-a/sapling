<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	type="tcy:get-app-view"
	version="2.0">
	
	<p:option name="path" required="true" />
	<p:option name="id" required="true" />
	<p:option name="for-graph" select="false()" />
	
	
	<p:output port="result" sequence="false">
		<p:pipe port="result" step="get-xml" />
	</p:output>

	<p:xquery name="get-xml">
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
							declare variable $for-graph as xs:boolean external;
							
							data:view-app-xml($path, $id, $for-graph)
						]]>
				</c:query>
			</p:inline>		
		</p:input>
		<p:with-param name="path" select="$path" />
		<p:with-param name="id" select="$id" />
		<p:with-param name="for-graph" select="$for-graph" />
	</p:xquery>	
	
</p:declare-step>
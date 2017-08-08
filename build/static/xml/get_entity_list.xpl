<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	type="tcy:query-get-entity-list"
	version="2.0">
	
	<p:option name="path" required="true" />
	
	<p:output port="result" sequence="true" />
	
	<p:xquery name="get-entity-list">
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
							
							data:get-entity-list($path)
					]]>
				</c:query>
			</p:inline>		
		</p:input>
		<p:with-param name="path" select="$path" />
	</p:xquery>
	
</p:declare-step>
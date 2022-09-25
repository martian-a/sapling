<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	name="filter-network-by-direction"
	type="tcy:filter-network-by-direction"
	version="3.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Reduce the network to ancestors or descendants of a specified node.</d:p>
		</d:desc>
	</p:documentation>
	
	<p:import href="../../../utils/debug.xpl" />
	
	<p:input port="source" primary="true" sequence="false" />
	
	<p:output port="result" sequence="false" />
	
	<p:option name="direction" required="false" as="xs:string?" />
	<p:option name="anchor-person-id" required="true" as="xs:string" />

	
	<p:choose>
		<p:when test="$direction = 'descendants'">
			<p:xslt> 
				<p:with-input port="stylesheet">
					<p:document href="descendants.xsl" />
				</p:with-input>
				<p:with-option name="parameters" select="map{'anchor-person-id': $anchor-person-id}" />
			</p:xslt>
		</p:when>
		<p:otherwise>
			<p:xslt> 
				<p:with-input port="stylesheet">
					<p:document href="ancestors.xsl" />
				</p:with-input>
				<p:with-option name="parameters" select="map{'anchor-person-id': $anchor-person-id}" />
			</p:xslt>
		</p:otherwise>
	</p:choose>
	
</p:declare-step>
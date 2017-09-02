<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="generate-xquery-config"
	type="tcy:generate-xquery-config"
	version="2.0">
	
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Creates a custom XQuery config file that defines the distribution data collection as the database.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:input port="config" primary="true" />

	<p:option name="target" select="''" />
	<p:option name="role" required="true" />
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results" />
	</p:output>
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Create a custom XQuery module.</d:desc>
			<d:note>
				<d:p>This config replaces the one used in the app, so that the db collection points to the dist data (which may be a subset of the entire data collection).</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:xslt>
		<p:input port="source" />
		<p:input port="stylesheet">
			<p:inline>
				<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
					xmlns:xs="http://www.w3.org/2001/XMLSchema"
					xmlns:c="http://www.w3.org/ns/xproc-step"
					exclude-result-prefixes="#all"
					version="2.0">
					
					<xsl:param name="role" required="yes" />
					
					<xsl:output encoding="UTF-8" media-type="text/xml" method="xml" indent="yes" />
					
					<xsl:template match="/">
						<c:data>
							xquery version "3.0";
							module namespace config = "http://ns.thecodeyard.co.uk/xquery/settings/config";
							declare variable $config:db := collection("<xsl:value-of select="/build/output/data[@role = $role]/@href/substring-after(., 'file://')" />");
						</c:data>
					</xsl:template>
					
				</xsl:stylesheet>
			</p:inline>
		</p:input>
		<p:with-param name="role" select="$role" />
	</p:xslt>
	
	<p:store name="store-xquery-config" encoding="UTF-8" media-type="text/xquery" method="text" omit-xml-declaration="true">
		<p:with-option name="href" select="concat($target, 'config.xq')" />
	</p:store>
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of paths to the generated files.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:created">
		<p:input port="source">
			<p:pipe port="result" step="store-xquery-config" />
		</p:input>
	</p:wrap-sequence>
	
	<p:add-attribute name="results" attribute-name="step" attribute-value="generate-custom-config" match="/*" />
	
</p:declare-step>
<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:k="http://schema.kaikoda.com/ns/xproc" type="k:show-people" name="show-people" version="1.0">

	<p:input port="source" sequence="false" primary="true" />

	<p:output port="result" sequence="false" primary="true">
		<p:pipe step="transform" port="result" />
	</p:output>
	
	<p:option name="root-publication-directory" required="true" />  		 

	<p:xslt version="1.0" name="transform">			
		
		<p:input port="source">
			<p:pipe step="show-people" port="source" />
		</p:input>	
		
		<p:input port="stylesheet">
			<p:document href="../../xslt/people/show_people.xsl"/>
			<!-- The xsl:result-document is output to the (default) secondary output port of this step -->
		</p:input>
		
		<p:input port="parameters">
			<p:empty />
		</p:input>
		
		<p:with-param name="root-publication-directory" select="$root-publication-directory" />		
		
	</p:xslt>
	
	<!-- store the xsl:result-document output by the transform step -->
	<p:for-each>
		<p:iteration-source>			
			<p:pipe step="transform" port="secondary"/>
		</p:iteration-source>
		<p:store>
			<p:with-option name="href" select="p:base-uri()"/>
		</p:store>
	</p:for-each>
	
</p:declare-step>
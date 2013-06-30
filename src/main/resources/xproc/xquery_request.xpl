<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:k="http://schema.kaikoda.com/ns/xproc" type="k:xquery-request" version="1.0">	
	
	<p:option name="uri" required="true" />			
			
	<p:output port="result" sequence="false" primary="true">
		<p:pipe step="request" port="result" />
	</p:output>		
			
	<p:load name="request"> 
		<p:with-option name="href" select="$uri" />
	</p:load> 
	
</p:declare-step>
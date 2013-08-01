<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:k="http://schema.kaikoda.com/ns/xproc" type="k:get-person-data" version="1.0">
				
	<p:option name="id" required="true" />
	
	<p:output port="result" sequence="false" primary="true">
		<p:pipe step="xquery-request" port="result" />
	</p:output>
	
	<p:import href="../library.xpl"/>	

	<k:xquery-request name="xquery-request">
		<p:with-option name="uri" select="concat('http://localhost:8080/exist/apps/sapling-test/queries/person.xq?id=', $id)"></p:with-option>
	</k:xquery-request>	
	
</p:declare-step>
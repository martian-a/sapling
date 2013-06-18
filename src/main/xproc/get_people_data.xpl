<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:k="http://schema.kaikoda.com/ns/xproc" type="k:get-people-data" version="1.0">
	
	<p:input port="source">
		<p:document href="http://localhost:8080/exist/apps/sapling-test/queries/people_index.xq" />
	</p:input>
	
	<p:output port="result" sequence="false" />
	
	<p:identity/>
	
</p:declare-step>
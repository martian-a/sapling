<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:k="http://schema.kaikoda.com/ns/xproc" type="k:get-person-data" version="1.0">
	
	<p:input port="source" sequence="false" primary="true">
		<p:inline>
			<p:document>
				<sapling>Hello World!</sapling>
			</p:document>
		</p:inline>
	</p:input>
	
	<p:option name="id" required="true" />
	
	<p:output port="result" sequence="false" primary="true" />
	
	<p:identity />
	
</p:declare-step>
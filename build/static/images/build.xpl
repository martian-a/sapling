<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="build-static-images"
	type="tcy:build-static-images"
	version="2.0">
	
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Generates network visualisations for the immediate family of every person in the core distribution data.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:input port="config" primary="true" />	
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="generate-family-tree" />
	</p:output>
	
	<p:import href="generate_family_tree.xpl" />

	<tcy:generate-family-tree name="generate-family-tree">
		<p:input port="config">
			<p:pipe port="config" step="build-static-images" />
		</p:input>
	</tcy:generate-family-tree>
	
</p:declare-step>
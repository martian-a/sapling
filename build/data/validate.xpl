<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="validate-data"
	type="tcy:validate-data"
	version="2.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Copies source XML files to the destination specified.</d:p>
		</d:desc>
	</p:documentation>
	
	<p:input port="config" primary="true" />
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="validate" />
	</p:output>
	
	<p:option name="scope" />
	<p:option name="role" select="'core'" />
	
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:import href="../../../genealogy-data-global/utils/xproc/build.xpl" />
	<p:import href="pre-process/pre_process.xpl" />
		
	<p:import href="generate_name_entities.xpl" />

	<p:variable name="href" select="/build/source/data[@role = $role]/@href" />
	<p:variable name="target" select="/build/output/data[@role = 'temp']/@href" />
	
	<cxf:mkdir name="create-dir">
		<p:with-option name="href" select="$target" />
	</cxf:mkdir>

	<p:for-each name="update-sources">
		
		<p:iteration-source select="/build/source/data[@role = ('core', 'shared')]">
			<p:pipe port="config" step="validate-data" />
		</p:iteration-source>
		
		<p:group>
			
			<tcy:build-sources>
				<p:input port="source">
					<p:empty />
				</p:input>
				<p:input port="parameters">
					<p:empty />
				</p:input>
				<p:with-option name="href" select="concat(data/@href, 'sources/')"/>
			</tcy:build-sources>
			
			<p:sink />
			
		</p:group>
		
	</p:for-each>


	<p:group name="pre-process-app-data">
		
		<p:output port="result" sequence="false" />
		
		<p:variable name="source-file-path" select="concat($href, 'app.xml')" />
		
		<p:load name="source-data" dtd-validate="false">
			<p:with-option name="href" select="$source-file-path" />
		</p:load>


		<p:xslt> 
			<p:input port="stylesheet">
				<p:document href="pre-process/merge_data_sources.xsl" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
		</p:xslt>
		
		
		<p:xslt> 
			<p:input port="stylesheet">
				<p:document href="pre-process/dereference_serials.xsl" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
		</p:xslt>
		
	</p:group>
	
	
	<p:store encoding="UTF-8" byte-order-mark="false" indent="true">
		<p:with-option name="href" select="concat($target, $role, '.xml')" />
	</p:store>
	
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Validate the merged and de-referenced data.</d:desc>
		</d:doc>
	</p:documentation>
	<p:validate-with-relax-ng assert-valid="true" name="validate">
		<p:input port="source">
			<p:pipe port="result" step="pre-process-app-data" />
		</p:input>
		<p:input port="schema">
			<p:data href="../../../sapling/schemas/sapling/sapling.rnc" content-type="text/plain"/>
		</p:input>
	</p:validate-with-relax-ng>
	
	
</p:declare-step>
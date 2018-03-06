<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="build-data"
	type="tcy:build-data"
	version="2.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Copies source XML files to the destination specified.</d:p>
		</d:desc>
	</p:documentation>
	
	<p:input port="config" primary="true" />
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results" />
	</p:output>
	
	<p:documentation>
		<d:doc>
			<d:desc>Whether or not all data should be included (private) or just data cleared for publishing publicly (public).</d:desc>
			<d:note>
				<d:ul>
					<d:ingress>Recognises the following values:</d:ingress>
					<d:li>private</d:li>
					<d:li>public</d:li>
				</d:ul>
				<d:p>The default value is 'public'.</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:option name="scope" select="'public'" />
	
	<p:option name="role" select="'core'" />
	
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:import href="../../../genealogy-data-global/build/sources/build.xpl" />
	<p:import href="pre-process/pre_process.xpl" />
		
	<p:import href="generate_name_entities.xpl" />

	<p:variable name="href" select="/build/source/data[@role = $role]/@href" />
	<p:variable name="target" select="/build/output/data[@role = $role]/@href" />
	
	<cxf:mkdir name="create-dir">
		<p:with-option name="href" select="$target" />
	</cxf:mkdir>

	<p:for-each name="update-sources">
		
		<p:iteration-source select="/build/source/data[@role = ('core', 'shared')]">
			<p:pipe port="config" step="build-data" />
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
		<p:variable name="temp-file-path" select="concat(/build/output/data[@role = 'temp']/@href, $role, '.xml')">
			<p:pipe port="config" step="build-data" />
		</p:variable>
		
		<p:load name="source-data" dtd-validate="false">
			<p:with-option name="href" select="$source-file-path" />
		</p:load>

		<tcy:pre-process-data>
			<p:input port="source">
				<p:pipe port="result" step="source-data" />
			</p:input>
			<p:with-option name="scope" select="$scope" />
			<p:with-option name="target" select="$temp-file-path" />			
		</tcy:pre-process-data>
		
	</p:group>
	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Store the data.</d:desc>
		</d:doc>
	</p:documentation>
	<p:group name="store-data">
		
		<p:output port="result" sequence="true" />
								
		<p:for-each name="collection">
			
			<p:iteration-source select="/app/data/*">
				<p:pipe port="result" step="pre-process-app-data" />
			</p:iteration-source>
			
			<p:group>

				<p:store name="store" 
					indent="false" 
					omit-xml-declaration="false" 
					encoding="utf-8" 
					method="xml" 
					media-type="text/xml">
					<p:input port="source">
						<p:pipe port="current" step="collection" />
					</p:input>
					<p:with-option name="href" select="concat($target, /*/name(), '.xml')" />
				</p:store>
				
				<p:documentation>
					<d:doc scope="step">
						<d:desc>Return a path to where the copied data has been stored.</d:desc>
					</d:doc>
				</p:documentation>
				<p:identity>
					<p:input port="source">
						<p:pipe port="result" step="store" />
					</p:input>
				</p:identity>
				
				<p:wrap match="/" wrapper="included" />		
				
				
			</p:group>
			
		</p:for-each>		
								
	</p:group>
	
	
	<p:sink />
	
	<p:group name="post-process-app-data">
		
		<p:output port="result" sequence="false" />
		
		<p:load name="load-stylesheet" dtd-validate="false" href="post-process-app-data.xsl" />
		
		<p:xslt name="modify-xml"> 
			<p:input port="stylesheet">
				<p:pipe port="result" step="load-stylesheet" />
			</p:input>
			<p:input port="source">
				<p:pipe port="result" step="pre-process-app-data" />
			</p:input>
			<p:input port="parameters">
				<p:empty />
			</p:input>
		</p:xslt>
		
		<p:store name="store" 
			indent="false" 
			omit-xml-declaration="false" 
			encoding="utf-8" 
			method="xml" 
			media-type="text/xml">
			<p:input port="source">
				<p:pipe port="result" step="modify-xml" />
			</p:input>
			<p:with-option name="href" select="concat($target, 'app.xml')" />
		</p:store>
		
		<p:documentation>
			<d:doc scope="step">
				<d:desc>Return a path to where the copied data has been stored.</d:desc>
			</d:doc>
		</p:documentation>
		<p:identity>
			<p:input port="source">
				<p:pipe port="result" step="store" />
			</p:input>
		</p:identity>
		
		<p:wrap match="/" wrapper="included" />		
		
	</p:group>
	
	
	<tcy:generate-name-entities name="generate-name-entities">
		<p:input port="config">
			<p:pipe port="config" step="build-data" />
		</p:input>
		<p:with-option name="target" select="concat($target, 'names.xml')" />
		<p:with-option name="role" select="$role"></p:with-option>
	</tcy:generate-name-entities>

	
	<p:documentation>
		<d:doc scope="step">
			<d:desc>Return a list of paths to the copied data files.</d:desc>
		</d:doc>
	</p:documentation>
	<p:wrap-sequence wrapper="c:created">
		<p:input port="source">
			<p:pipe port="result" step="store-data" />
			<p:pipe port="result" step="post-process-app-data" />
			<p:pipe port="result" step="generate-name-entities" />
		</p:input>
	</p:wrap-sequence>
	
	<p:add-attribute name="results" attribute-name="step" attribute-value="build-data" match="/*" />
	
</p:declare-step>
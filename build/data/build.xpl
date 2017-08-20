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
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Copies source XML files to the destination specified.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:option name="scope" />
	<p:option name="role" select="'core'" />
	
	<p:input port="config" primary="true" />
	
	<p:output port="result" sequence="true">
		<p:pipe port="result" step="results" />
	</p:output>
	
	<p:import href="generate_name_entities.xpl" />

	<p:variable name="href" select="/build/source/data[@role = $role]/@href" />
	<p:variable name="target" select="/build/output/data[@role = $role]/@href" />

	<p:for-each name="copy-set">
		
		<p:iteration-source select="/build/source/data[@role = $role]/set" />
		
		<p:group>
			
			<p:variable name="include-filter" select="set/include/@filter" />
			<p:variable name="exclude-filter" select="set/exclude/@filter" />
			<p:variable name="stylesheet" select="set/stylesheet/@href" />
			
			
			<p:documentation>
				<d:doc>
					<d:desc>Generate a listing of the contents of the directory referenced by $href.</d:desc>
				</d:doc>
			</p:documentation>
			<p:directory-list name="directory-listing">
				<p:with-option name="path" select="$href"/>
				<p:with-option name="include-filter" select="$include-filter" />
				<p:with-option name="exclude-filter" select="$exclude-filter" />
			</p:directory-list>
			
			
			<p:documentation>
				<d:doc>
					<d:desc>
						<d:p>Iterate through the result returned by the directory-listing step.</d:p>
						<d:p>For each file or directory, determine whether it's intended for publishing.  If it is, make a copy in the same location, relative to the $target directory.</d:p>
					</d:desc>
				</d:doc>
			</p:documentation>
			<p:for-each name="copy-files">
				
				<p:iteration-source select="c:directory/*:file">
					<p:pipe port="result" step="directory-listing" />
				</p:iteration-source>
				
				<p:group name="copy-file">
					
					<p:documentation>
						<d:doc scope="step">
							<d:desc>Determine the name of the source file.</d:desc>
						</d:doc>
					</p:documentation>
					<p:variable name="filename" select="c:file/@name" />
					
					<p:variable name="source-file-path" select="concat($href, '/', $filename)" />
					
					<p:load name="source-data" dtd-validate="false">
						<p:with-option name="href" select="$source-file-path" />
					</p:load>
					
					<p:group>
						
						<p:variable name="publish" select="if (/*/@publish) then /*/@publish else true()">
							<p:pipe port="result" step="source-data" />
						</p:variable>
						
						<p:choose>
							<p:when test="$scope = 'private' or ($scope = 'public' and $publish = true())">
								
								<p:choose>
									
									<p:when test="$stylesheet != ''">
										
										<p:load name="load-stylesheet" dtd-validate="false">
											<p:with-option name="href" select="$stylesheet" />
										</p:load>
										
										<p:xslt name="modify-xml"> 
											<p:input port="stylesheet">
												<p:pipe port="result" step="load-stylesheet" />
											</p:input>
											<p:input port="source">
												<p:pipe port="result" step="source-data" />
											</p:input>
											<p:input port="parameters">
												<p:empty />
											</p:input>
										</p:xslt> 
										
									</p:when>
									
									<p:otherwise>
										
										<p:identity>
											<p:input port="source">
												<p:pipe port="result" step="source-data" />
											</p:input>
										</p:identity>
										
									</p:otherwise>
									
								</p:choose>
								
								<p:identity name="output-data"/>
								
								<p:documentation>
									<d:doc scope="step">
										<d:desc>Store the data.</d:desc>
									</d:doc>
								</p:documentation>
								<p:store name="store" 
									indent="true" 
									omit-xml-declaration="false" 
									encoding="utf-8" 
									method="xml" 
									media-type="text/xml">
									<p:input port="source">
										<p:pipe port="result" step="output-data" />
									</p:input>
									<p:with-option name="href" select="concat($target, '/', $filename)" />
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
								
							</p:when>
							<p:otherwise>
								
								<p:identity>
									<p:input port="source">
										<p:pipe port="current" step="copy-files" />
									</p:input>
								</p:identity>
								
								<p:wrap match="/" wrapper="excluded" />
								
							</p:otherwise>
						</p:choose>
						
					</p:group>
					
				</p:group>
				
				
			</p:for-each>
			
		</p:group>

	</p:for-each>
	
	<p:sink />
	
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
			<p:pipe port="result" step="copy-set" />
			<p:pipe port="result" step="generate-name-entities" />
		</p:input>
	</p:wrap-sequence>
	
	<p:add-attribute name="results" attribute-name="step" attribute-value="build-data" match="/*" />
	
</p:declare-step>
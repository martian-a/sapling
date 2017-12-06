<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	version="2.0"
	type="tcy:copy-dependencies">
	
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Generates an HTML view of data held about TTR maps.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory where the dependencies are stored.</d:desc>
			<d:note>
				<d:p>For example: file:///projects/greenwood/app/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:option name="href" required="true" />
	
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory where output results should be stored.</d:desc>
			<d:note>
				<d:p>For example: file:///projects/greenwood/dist/www/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:option name="target" required="true" />
	
	<p:option name="include-filter" />
	<p:option name="exclude-filter" />
	
	
	<p:output port="result" sequence="true" />
	
	<p:import href="http://xmlcalabash.com/extension/steps/library-1.0.xpl"/>
	<p:import href="../../utils/recursive_copy_directory.xpl" />


	<p:choose name="directory-listing">
		<p:when test="p:value-available('include-filter')
			and p:value-available('exclude-filter')">
			<p:directory-list>
				<p:with-option name="path" select="$href"/>
				<p:with-option name="include-filter" select="$include-filter"/>
				<p:with-option name="exclude-filter" select="$exclude-filter"/>
			</p:directory-list>
		</p:when>
		
		<p:when test="p:value-available('include-filter')">
			<p:directory-list>
				<p:with-option name="path" select="$href"/>
				<p:with-option name="include-filter" select="$include-filter"/>
			</p:directory-list>
		</p:when>
		
		<p:when test="p:value-available('exclude-filter')">
			<p:directory-list>
				<p:with-option name="path" select="$href"/>
				<p:with-option name="exclude-filter" select="$exclude-filter"/>
			</p:directory-list>
		</p:when>
		
		<p:otherwise>
			<p:directory-list>
				<p:with-option name="path" select="$href"/>
			</p:directory-list>
		</p:otherwise>
	</p:choose>
	

	
	<p:for-each name="copy-dependencies">
		
		<p:iteration-source select="c:directory/*" />
		
		<p:output port="result" sequence="true" />

		<p:group>
			
			<p:variable name="local-path" select="*/@name" />
			
			
			<!-- js, css, images, fonts -->
		
			<p:choose>
				
				<p:xpath-context>
					<p:pipe port="current" step="copy-dependencies" />
				</p:xpath-context>
				
				<p:when test="/c:file">
					
					<cxf:copy name="copy-file">
						<p:with-option name="href" select="concat($href, '/', $local-path)" />
						<p:with-option name="target" select="concat($target, '/', $local-path)" />
					</cxf:copy>
					
					<p:identity>
						<p:input port="source">
							<p:pipe port="result" step="copy-file" />
						</p:input>
					</p:identity>
					
				</p:when>				
				<p:otherwise>
					
					<p:documentation>
						<d:doc scope="step">
							<d:desc>Copy javascript assets that the result will depend on to the output directory.</d:desc>
						</d:doc>
					</p:documentation>
					<tcy:recursive-copy-directory>
						<p:with-option name="href" select="concat($href, '/', $local-path, '/')" />
						<p:with-option name="target" select="concat($target, '/', $local-path, '/')" />
					</tcy:recursive-copy-directory>
						
				</p:otherwise>
			</p:choose>
		
		</p:group>
		
	</p:for-each>

	
</p:declare-step>
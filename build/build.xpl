<?xml version="1.0" encoding="UTF-8"?>
<p:pipeline
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="build"
	version="2.0">
	
	
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Generates a static snapshot (XML, HTML) of content in the app.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
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
	
	
	<p:documentation>
		<d:doc>
			<d:desc>What the build process should produce.</d:desc>
			<d:note>
				<d:ul>
					<d:ingress>Recognises the following values:</d:ingress>
					<d:li>data</d:li>
					<d:li>static-html</d:li>
					<d:li>all</d:li>
				</d:ul>
				<d:p>The default value is 'static-html'.</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:option name="product" select="'static-html'" />
	
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory containing the source data file(s).</d:desc>
			<d:note>
				<d:p>For example: file:///project/data/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:variable name="href-source-data" select="/build/source/data/@href" />
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory containing the source app file(s).</d:desc>
			<d:note>
				<d:p>For example: file:///project/app/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:variable name="href-source-app" select="/build/source/app/@href" />
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory where output data should be stored.</d:desc>
			<d:note>
				<d:p>For example: file:///project/dist/data/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:variable name="href-output-data" select="/build/output/data/@href" />
	
	<p:documentation>
		<d:doc>
			<d:desc>A URL to the directory where output site should be stored.</d:desc>
			<d:note>
				<d:p>For example: file:///project/dist/www/</d:p>
			</d:note>
		</d:doc>
	</p:documentation>
	<p:variable name="href-output-site" select="/build/output/site/@href" />
	
	
	
	<p:import href="http://xmlcalabash.com/extension/steps/fileutils.xpl"/>
	<p:import href="utils/recursive_delete_directory.xpl"/>
	<p:import href="utils/clean.xpl"/>
	<p:import href="data/build.xpl" />
	<p:import href="static/xml/build.xpl" />
	<p:import href="static/html/build.xpl" />
	
	<p:group>

		<p:output port="result" sequence="true">
			<p:pipe port="result" step="clean" />
			<p:pipe port="result" step="build-data" />
			<p:pipe port="result" step="build-xml" />
			<p:pipe port="result" step="build-html" />
			<p:pipe port="result" step="delete" />
		</p:output>
		
		<p:group name="clean">
			
			<p:output port="result" sequence="true">
				<p:pipe port="result" step="clean-data" />
				<p:pipe port="result" step="clean-site" />
			</p:output>
			
			<tcy:clean name="clean-data">
				<p:with-option name="href" select="$href-output-data" />	
			</tcy:clean>
			
			<p:sink />
			
			<tcy:clean name="clean-site">
				<p:with-option name="href" select="$href-output-site" />	
			</tcy:clean>
			
			<p:sink />
			
		</p:group>
		
		<p:sink />
		
		
		<p:documentation>
			<d:doc scope="step">
				<d:desc>Copy and prepare the data into the structure(s) required for distribution.</d:desc>
			</d:doc>
		</p:documentation>
		<tcy:build-data name="build-data">
			<p:input port="config">
				<p:pipe port="source" step="build" />
			</p:input>
			<p:with-option name="scope" select="$scope" />
		</tcy:build-data>
		
		<p:sink />
		
		
		<p:documentation>
			<d:doc scope="step">
				<d:desc>Generate a snapshot of the XML that would currently be returned by the app.</d:desc>
			</d:doc>
		</p:documentation>
		<tcy:build-static-xml name="build-xml">
			<p:input port="config">
				<p:pipe port="source" step="build" />
			</p:input>
		</tcy:build-static-xml>
		
		<p:sink />
		

		<p:documentation>
			<d:doc scope="step">
				<d:desc>Generate a snapshot of the HTML that would currently be returned by the app.</d:desc>
			</d:doc>
		</p:documentation>
		<tcy:build-static-html name="build-html">
			<p:input port="config">
				<p:pipe port="source" step="build" />
			</p:input>
		</tcy:build-static-html>
		
		<p:sink />
		
		
		<p:documentation>
			<d:doc scope="step">
				<d:desc>Delete the XML snapshot as not deployed with site.</d:desc>
			</d:doc>
		</p:documentation>
		<p:group name="delete">
			
			<p:output port="result" sequence="true">
				<p:pipe port="result" step="clean-data" />
				<p:pipe port="result" step="clean-site" />
			</p:output>
			
			<p:choose>
				<p:when test="$product = ('data', 'all')">
					<p:identity>
						<p:input port="source">
							<p:empty />
						</p:input>
					</p:identity>
				</p:when>
				<p:otherwise>
					<tcy:clean>
						<p:with-option name="href" select="$href-output-data" />	
					</tcy:clean>
				</p:otherwise>
			</p:choose>
			
			<p:identity name="clean-data" />
			
			<p:sink />
			
			<p:choose>
				<p:when test="$product = 'static-html'">
					<tcy:clean>
						<p:with-option name="href" select="concat($href-output-site, '/xml/')" />	
					</tcy:clean>
				</p:when>
				<p:when test="$product = 'data'">
					<tcy:clean>
						<p:with-option name="href" select="$href-output-site" />	
					</tcy:clean>
				</p:when>
				<p:otherwise>
					<p:identity>
						<p:input port="source">
							<p:empty />
						</p:input>
					</p:identity>
				</p:otherwise>
			</p:choose>
			
			<p:identity name="clean-site" />
			
			<p:sink />
			
		</p:group>
		
		<p:sink />
		
	</p:group>
	
	
	<p:wrap-sequence wrapper="c:results" />

		
</p:pipeline>
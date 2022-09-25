<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="file:///home/sheila/Tools/xproc-schemas/xproc30.rnc" type="application/relax-ng-compact-syntax"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    name="who-what-when-where"
    type="tcy:who-what-when-where"
    version="3.0">

	<p:import href="../../build/utils/collate-output-file-locations/collate-output-file-locations.xpl" />
	<p:import href="../../build/utils/store.xpl" />
	<p:import href="../../build/utils/debug.xpl" />

    <p:input port="source" primary="true" content-types="xml" />
    <p:output port="result" sequence="true"/>
	
	<p:option name="path-to-output-folder" select="'../output/'" />
	<p:option name="name-variants" select="()" />
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
	
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
	
	<p:sink />

    <p:xslt>
        <p:with-input port="stylesheet">
            <p:document href="people_by_location.xsl" />
        </p:with-input>
    	<p:with-input port="source">
    		<p:pipe port="source" step="who-what-when-where" />
    	</p:with-input>
    </p:xslt>
	
	<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="people_by_location" name="store-people-by-location">
		<p:with-option name="serialization" select="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}" />
	</tcy:store>
            	
	<p:sink />
	
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="people_by_name.xsl" />
		</p:with-input>
		<p:with-input port="source">
			<p:pipe port="source" step="who-what-when-where" />
		</p:with-input>
	</p:xslt>
	
	<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="people_by_name" name="store-people-by-name">
		<p:with-option name="serialization" select="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}" />
	</tcy:store>
	
	<p:sink />
	
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="people_by_time.xsl" />
		</p:with-input>
		<p:with-input port="source">
			<p:pipe port="source" step="who-what-when-where" />
		</p:with-input>
	</p:xslt>
	
	<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="people_by_time" name="store-people-by-time">
		<p:with-option name="serialization" select="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}" />
	</tcy:store>
	
	<p:sink />
	
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="locations_by_event.xsl" />
		</p:with-input>
		<p:with-input port="source">
			<p:pipe port="source" step="who-what-when-where" />
		</p:with-input>
	</p:xslt>
	
	<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="locations_by_event" name="store-locations-by-event">
		<p:with-option name="serialization" select="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}" />
	</tcy:store>
	
	<p:sink />	
	
	
	<p:for-each name="timelines">
		
		<p:with-input select="/timeline/year/text()">
			<p:inline>
				<timeline>
					<year>1841</year>
					<year>1851</year>
					<year>1861</year>
					<year>1871</year>
					<year>1881</year>
					<year>1891</year>
					<year>1901</year>
					<year>1911</year>
					<year>1921</year>
					<year>1939</year>
				</timeline>
			</p:inline>
		</p:with-input>
		
		<p:output port="result" sequence="true" />
		
		<p:group>
			
			<p:variable name="census-year" select=".">
				<p:pipe port="current" />				
			</p:variable>
			
			<p:xslt>
				<p:with-input port="stylesheet">
					<p:document href="people_by_census_year.xsl" />
				</p:with-input>
				<p:with-input port="source">
					<p:pipe port="source" step="who-what-when-where" />
				</p:with-input>
				<p:with-option name="parameters" select="map{'census-year' : $census-year, 'name-variants' : $name-variants}" /> 
			</p:xslt>
			
			<tcy:store path-to-output-folder="{$path-to-output-folder}" filename="people_by_census_year/{$census-year}" name="store-timeline">
				<p:with-option name="serialization" select="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}" />
			</tcy:store>
			
			<p:sink />


			<p:identity>
				<p:with-input port="source">
					<p:pipe step="store-timeline" port="result-uri" />
				</p:with-input>
			</p:identity>
		
		</p:group>
		
	</p:for-each>
	
	<p:sink />	
		
	<tcy:collate-output-file-locations>
		<p:with-input port="source">
			<p:pipe port="result" step="timelines" />
			<p:pipe port="result-uri" step="store-locations-by-event" />
			<p:pipe port="result-uri" step="store-people-by-time" />
			<p:pipe port="result-uri" step="store-people-by-name" />
			<p:pipe port="result-uri" step="store-people-by-location" />
		</p:with-input>
	</tcy:collate-output-file-locations>
	
</p:declare-step>
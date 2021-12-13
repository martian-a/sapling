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
        
    <p:input port="source" primary="true" content-types="xml" />
    <p:output port="result" sequence="true"/>
	
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
	
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
	<p:variable name="dataset-name" select="/data/void:dataset/@void:name" />
	
	<p:sink />

    <p:xslt>
        <p:with-input port="stylesheet">
            <p:document href="people_by_location.xsl" />
        </p:with-input>
    	<p:with-input port="source">
    		<p:pipe port="source" step="who-what-when-where" />
    	</p:with-input>
    </p:xslt>
            
	<p:store serialization="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}">
		<p:with-option name="href" select="concat('../output/', $dataset-name, '/people_by_location.html')" />
	</p:store>        
                
	<p:sink />
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="people_by_name.xsl" />
		</p:with-input>
		<p:with-input port="source">
			<p:pipe port="source" step="who-what-when-where" />
		</p:with-input>
	</p:xslt>
	
	<p:store serialization="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}">
		<p:with-option name="href" select="concat('../output/', $dataset-name, '/people_by_name.html')" />
	</p:store>
	
	<p:sink />
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="people_by_time.xsl" />
		</p:with-input>
		<p:with-input port="source">
			<p:pipe port="source" step="who-what-when-where" />
		</p:with-input>
	</p:xslt>
	
	<p:store serialization="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}">
		<p:with-option name="href" select="concat('../output/', $dataset-name, '/people_by_time.html')" />
	</p:store>
	
	<p:sink />
	
	<p:xslt>
		<p:with-input port="stylesheet">
			<p:document href="locations_by_event.xsl" />
		</p:with-input>
		<p:with-input port="source">
			<p:pipe port="source" step="who-what-when-where" />
		</p:with-input>
	</p:xslt>
	
	<p:store serialization="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}">
		<p:with-option name="href" select="concat('../output/', $dataset-name, '/locations_by_event.html')" />
	</p:store>
	
	<p:sink />	
	
	
	<p:for-each>
		
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
				<p:with-option name="parameters" select="map{'census-year' : $census-year }" /> 
			</p:xslt>
			
			<p:store serialization="map{'method' : 'html', 'version' : '5', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'text/html'}">
				<p:with-option name="href" select="concat('../output/', $dataset-name, '/people_by_census_year/', $census-year, '.html')" />
			</p:store>
		
		</p:group>
		
	</p:for-each>
	
	<p:sink />	
	
	
	<p:identity message="Analysis HTML updated.">
		<p:with-input port="source">
			<p:empty />
		</p:with-input>
	</p:identity>
	
</p:declare-step>
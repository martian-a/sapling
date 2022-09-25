<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="sapling-to-analysis"
    type="tcy:sapling-to-analysis"
    version="3.0">
    	
	<p:import href="../../../../analysis/who-what-when-where/who_what_when_where.xpl" />
	<p:import href="../../network/network-to-d3/network2d3.xpl" />
	<p:import href="../../../utils/collate-output-file-locations/collate-output-file-locations.xpl" />
	<p:import href="../../../../analysis/consistency-checks/consistency_checks.xpl" />
    
    <p:input port="source" primary="true">
    	<p:document href="temp.xml" />
    </p:input>    
    <p:output port="result" sequence="true" />
    
	<p:option name="path-to-output-folder" select="'../output/'" />
	<p:option name="name-variants" select="()" />
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
 
	<p:variable name="pipeline-start-time" select="current-dateTime()" />    
	
	<p:for-each name="network-visualisations">
		
		<p:with-input select="//c:result[@schema = 'network']" />
		
		<p:output port="result" sequence="true" />
		
		<p:group>
			
			<p:variable name="uri" select="." as="xs:string" />
			
			<p:load name="load-network">
				<p:with-option name="href" select="$uri" />
			</p:load>
			
			<p:variable name="dataset-date" select="translate(substring((/*/*:document/*:activity/*:startTime)[1], 1, 10), '-', '')" as="xs:string" />
		
			<tcy:network-to-d3>
				<p:with-option name="generated-by-user" select="$generated-by-user" />
				<p:with-option name="debug" select="$debug" />
			</tcy:network-to-d3>
			
			<p:store serialization="map{'method' : 'text', 'encoding' : 'utf-8', 'indent' : 'true', 'media-type' : 'application/json'}" name="store-visualisation">
				<p:with-option name="href" select="string-join(($path-to-output-folder, $dataset-date, /c:result/@sub-dataset, concat(/c:result/@network-name, '.json')), '/')">
					<p:pipe port="current" step="network-visualisations" />
				</p:with-option>
			</p:store>  
			
			<p:sink />
			
			<p:identity>
				<p:with-input port="source">
					<p:pipe step="store-visualisation" port="result-uri" />
				</p:with-input>
			</p:identity>
			
		</p:group>
					
	</p:for-each>

	<p:sink />

	<p:for-each name="sapling-specific">
		
		<p:with-input select="//c:result[@schema = 'sapling']">
			<p:pipe step="sapling-to-analysis" port="source" />
		</p:with-input>
		
		<p:output port="result" sequence="true" />
		
		<p:group>
			
			<p:output port="result" sequence="true">
				<p:pipe step="who-what-where-when" port="result" />
				<p:pipe step="consistency-checks" port="result" />
			</p:output>
			
			<p:variable name="uri" select="." as="xs:string" />
			
			<p:load name="load-network">
				<p:with-option name="href" select="$uri" />
			</p:load>
    
			<tcy:who-what-when-where name="who-what-where-when">
				<p:with-option name="path-to-output-folder" select="$path-to-output-folder" />
				<p:with-option name="name-variants" select="$name-variants" />
				<p:with-option name="generated-by-user" select="$generated-by-user" />
				<p:with-option name="debug" select="$debug" />
			</tcy:who-what-when-where>  
			
			<p:sink />
			
			<tcy:sapling-consistency-checks name="consistency-checks">
				<p:with-input port="source">
					<p:pipe step="load-network" port="result" />
				</p:with-input>
				<p:with-option name="path-to-output-folder" select="$path-to-output-folder" />
				<p:with-option name="generated-by-user" select="$generated-by-user" />
				<p:with-option name="debug" select="$debug" />
			</tcy:sapling-consistency-checks>  
			
			<p:sink />
			
		</p:group>
		
	</p:for-each>
	
	<p:sink />
	
	<tcy:collate-output-file-locations>
		<p:with-input port="source">
			<p:pipe port="result" step="network-visualisations" />
			<p:pipe port="result" step="sapling-specific" />		
		</p:with-input>
	</tcy:collate-output-file-locations>
	
</p:declare-step>
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="file:///home/sheila/Tools/xproc-schemas/xproc30.rnc" type="application/relax-ng-compact-syntax"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="gedcom-xml-to-sapling"
    type="tcy:gedcom-xml-to-sapling"
    version="3.0">
    
	<p:import href="../debug.xpl" />
    <p:import href="../../../../../cenizaro/tools/schematron/validate-with-schematron.xpl" />
    
    <p:input port="source" primary="true" />
    <p:output port="result" sequence="true" />
    
	<p:option name="pipeline-username" required="false" />
    <p:option name="debug" select="'true'" />
 
	<p:xslt name="wrapper">
		<p:with-input port="stylesheet">
			<p:document href="create/wrapper.xsl" />
		</p:with-input>
		<p:with-option name="parameters" select="map{
			'generated-by-user': $pipeline-username,
			'generated-by-pipeline': resolve-uri(''),
			'transformation-start-time' : current-dateTime()
			}" />
	</p:xslt>
	
	<p:sink />
 
	<p:xslt name="locations">
		<p:with-input port="source">
			<p:pipe port="source" step="gedcom-xml-to-sapling" />
		</p:with-input>		
		<p:with-input port="stylesheet">
			<p:document href="create/locations.xsl" />
		</p:with-input>
	</p:xslt>   
	
	<p:sink />
	
	<p:xslt name="people">
		<p:with-input port="source">
			<p:pipe port="source" step="gedcom-xml-to-sapling" />
		</p:with-input>
		<p:with-input port="stylesheet">
			<p:document href="create/people.xsl" />
		</p:with-input>
	</p:xslt>
	
	<p:sink />
	
	<p:xslt name="events">
		<p:with-input port="source">
			<p:pipe port="source" step="gedcom-xml-to-sapling" />
		</p:with-input>
		<p:with-input port="stylesheet">
			<p:document href="create/events.xsl" />
		</p:with-input>
	</p:xslt>
	
	<p:sink />
    
	<p:insert match="/*" position="last-child">
		<p:with-input port="source">
			<p:pipe port="result" step="wrapper" />
		</p:with-input>
		<p:with-input port="insertion">
			<p:pipe port="result" step="people" />
		</p:with-input>
	</p:insert>
      
	<p:insert match="/*" position="last-child">
		<p:with-input port="insertion">
			<p:pipe port="result" step="events" />
		</p:with-input>
	</p:insert>
	
	<p:insert match="/*" position="last-child">
		<p:with-input port="insertion">
			<p:pipe port="result" step="locations" />
		</p:with-input>
	</p:insert>

	<p:xslt name="refine-locations">
		<p:with-input port="stylesheet">
			<p:document href="refine/locations.xsl" />
		</p:with-input>
	</p:xslt>
	
	<p:xslt name="refine-people">
		<p:with-input port="stylesheet">
			<p:document href="refine/people.xsl" />
		</p:with-input>
	</p:xslt>	
	    
	<tcy:debug file-extension="sapling.xml"  />         		
		
	<p:group name="validate-sapling-xml">
		
		<p:validate-with-relax-ng name="validate-sapling-rnc" assert-valid="true">
			<p:with-input port="schema">
				<p:document href="file:///home/sheila/Code/repositories/sapling/schemas/sapling/sapling-data.rnc" content-type="application/relax-ng-compact-syntax" />
			</p:with-input>
		</p:validate-with-relax-ng>
		
			
		<tcy:validate-with-schematron name="validate-sapling">
			<p:with-input port="schema">
				<p:document href="../../../../schemas/sapling/sapling.sch" />
			</p:with-input>
		</tcy:validate-with-schematron>
		
		
		<p:choose>   
			<p:with-input>
				<p:pipe port="outcome" step="validate-sapling" />        		
			</p:with-input>  
			<p:when test=". = 'invalid'">       
				
				<p:store href="validation-errors.html">
					<p:with-input port="source">
						<p:pipe port="report-html" step="validate-sapling" />
					</p:with-input>
				</p:store>            	
				
				<p:identity message="See validation-errors.html for report." />
				
				<p:sink />
				
				<p:error code="invalid-document">
					<p:with-input port="source">
						<p:pipe port="report-xml" step="validate-sapling" />
					</p:with-input>
				</p:error>              	
				
			</p:when>
			<p:otherwise>                
				<p:identity>
					<p:with-input port="source">
						<p:pipe port="result" step="validate-sapling" />
					</p:with-input>
				</p:identity>
			</p:otherwise>            
		</p:choose>    		
				
	</p:group>

       
</p:declare-step>
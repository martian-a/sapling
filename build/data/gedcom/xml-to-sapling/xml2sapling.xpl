<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="file:///home/sheila/Tools/xproc-schemas/xproc30.rnc" type="application/relax-ng-compact-syntax"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="gedcom-xml-to-sapling"
    type="tcy:gedcom-xml-to-sapling"
    version="3.0">
    
	<p:import href="../../provenance/insert-prov-metadata.xpl" />
	<p:import href="../debug.xpl" />
    <p:import href="../../../../../cenizaro/tools/schematron/validate-with-schematron.xpl" />
	<p:import href="../../../utils/uuid/replace-id-with-uuid.xpl" />
    
    <p:input port="source" primary="true" />
    <p:output port="result" sequence="true" />
    
	<p:option name="generated-by-user" required="false" /> 
    <p:option name="debug" select="'true'" />
 
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
 
	<p:group name="create-wrapper">
		
		<p:output port="result" sequence="false" />
		
		<p:xslt>
			<p:with-input port="stylesheet">
				<p:document href="create/wrapper.xsl" />
			</p:with-input>
		</p:xslt>	
			
		<!-- Add a UUID to the root element, if one doesn't already exist. -->
		<p:choose>
			<p:when test="normalize-space(/*/@uuid) = ''">
				<p:add-attribute match="/*" attribute-name="uuid" attribute-value="''" />     
				<p:uuid match="/*/@uuid" version="4" />
			</p:when>
		</p:choose>
	
	</p:group>
	
	<p:sink />
 
    <p:group name="locations">
    	
    	<p:output port="result" />
    	
    	<p:xslt>
    		<p:with-input port="source">
    			<p:pipe port="source" step="gedcom-xml-to-sapling" />
    		</p:with-input>		
    		<p:with-input port="stylesheet">
    			<p:document href="create/locations.xsl" />
    		</p:with-input>
    	</p:xslt>   

    	<p:for-each>
    		
    		<p:with-input select="//location[@id]" />
    		
    		<p:group>
    			
    			<p:hash algorithm="md" version="5" match="@id">
    				<p:with-option name="value" select="location/@id" />
    			</p:hash>
    			
    		</p:group>
    		
    	</p:for-each>
    	
    	<p:wrap-sequence wrapper="locations" />
    	
    </p:group>
	
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
	
	<p:xslt name="sources">
		<p:with-input port="source">
			<p:pipe port="source" step="gedcom-xml-to-sapling" />
		</p:with-input>
		<p:with-input port="stylesheet">
			<p:document href="create/sources.xsl" />
		</p:with-input>
	</p:xslt>
	
	<p:sink />
    
	<p:insert match="/*" position="last-child">
		<p:with-input port="source">
			<p:pipe port="result" step="create-wrapper" />
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
	
	<p:insert match="/*" position="last-child">
		<p:with-input port="insertion">
			<p:pipe port="result" step="sources" />
		</p:with-input>
	</p:insert>	
	
	<tcy:uuid>
		<p:with-input port="source" />
		<p:with-option name="replace-values" select="descendant::*/@*:id[starts-with(., 'REPLACE-')]" as="xs:string*" />
	</tcy:uuid>
			
	<p:xslt name="refine-ids">
		<p:with-input port="stylesheet">
			<p:document href="refine/ids.xsl" />
		</p:with-input>
	</p:xslt>	

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
	
	<p:xslt name="relocate-sources">
		<p:with-input port="stylesheet">
			<p:document href="refine/relocate-sources.xsl" />
		</p:with-input>
	</p:xslt>  
	
	<p:xslt name="dedupe-sources">
		<p:with-input port="stylesheet">
			<p:document href="refine/dedupe-sources.xsl" />
		</p:with-input>
	</p:xslt>   	
	   
	   
	<tcy:debug file-extension="sapling.xml"  />   
	
	
	<p:group name="result-provenance-metadata">
	
		<tcy:insert-prov-metadata name="prov-metadata">
			<p:with-option name="generated-by-user" select="$generated-by-user" />
			<p:with-option name="generated-by-pipeline" select="p:urify(resolve-uri(''))" />
			<p:with-option name="pipeline-start-time" select="$pipeline-start-time" />
			<p:with-option name="pipeline-end-time" select="current-dateTime()" />
			<p:with-option name="source-uri" select="p:urify(document-uri(/))">
				<p:pipe port="source" step="gedcom-xml-to-sapling" />
			</p:with-option>
		</tcy:insert-prov-metadata>  
		
		<tcy:debug file-extension="sapling.xml"  />   
			
	</p:group>

	<!--
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
	-->
       
</p:declare-step>
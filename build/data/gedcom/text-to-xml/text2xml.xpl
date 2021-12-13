<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="file:///home/sheila/Tools/xproc-schemas/xproc30.rnc" type="application/relax-ng-compact-syntax"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="gedcom-txt-to-xml"
    type="tcy:gedcom-txt-to-xml"
    version="3.0">
    
	<p:import href="../../provenance/insert-prov-metadata.xpl" />
	<p:import href="../debug.xpl" />
    <p:import href="../../../../../cenizaro/tools/schematron/validate-with-schematron.xpl" />
    
    <p:input port="source" primary="true" content-types="text" />
    <p:output port="result" sequence="true"/>
	
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
	
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
	
	<p:sink />
 
    <p:group name="gedcom-xml">       
                
        <p:output port="result" />
        
        <p:group name="create-wrapper">
        
	        <p:xslt>
	        	<p:with-input port="source">
	        		<p:pipe port="source" step="gedcom-txt-to-xml" />
	        	</p:with-input>
	            <p:with-input port="stylesheet">
	                <p:document href="create/file.xsl" />
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
    	
    	<tcy:debug file-extension="txt.xml" />
    	
    	<p:group name="insert-original-source-provenance">
    	
	    	<!-- Add a UUID to the entity representing the original source (txt) document in the provenance metadata. -->
	    	<p:add-attribute match="/file/prov:document" attribute-name="uuid" attribute-value="''" />     
	    	<p:uuid match="/file/prov:document/@uuid" version="4" />
	    		
	    	<!-- Add a hash of the original source (txt) document to the provenance metadata. -->
	    	<p:add-attribute match="/file/prov:document" attribute-name="hash" attribute-value="''" />         	
	    	<p:hash algorithm="md" match="/file/prov:document/@hash">
	    		<p:with-option name="value" select="serialize(/)">
	    			<p:pipe port="source" step="gedcom-txt-to-xml" />
	    		</p:with-option>
	    	</p:hash>
	    	      	     	    
    	</p:group>
    	
    	<tcy:debug file-extension="txt.xml" />
        
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/line.xsl" />
            </p:with-input>
        </p:xslt>
                
    	<tcy:debug file-extension="txt.xml" />
    	    	
    	<p:xslt>
    		<p:with-input port="stylesheet">
    			<p:document href="create/record.xsl" />
    		</p:with-input>
    	</p:xslt>                
                                             
    	<tcy:debug file-extension="txt.xml" />               
        
        
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/label.xsl" />
            </p:with-input>
        </p:xslt>    
        
    	<tcy:debug file-extension="txt.xml" />
        
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/unlabelled.xsl" />
            </p:with-input>
        </p:xslt>    
        
    	<tcy:debug file-extension="txt.xml" />
             
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/group.xsl" />
            </p:with-input>
        </p:xslt>    
        
    	<tcy:debug file-extension="txt.xml" />
                
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/supergroup.xsl" />
            </p:with-input>
        </p:xslt>   
        
    	<tcy:debug file-extension="txt.xml" />
                
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="refine/refine-ged-xml.xsl" />
            </p:with-input>
        </p:xslt>
        
    	<tcy:debug file-extension="txt.xml" />
    	
    	<p:xslt>
    		<p:with-input port="stylesheet">
    			<p:document href="refine/cross-references.xsl" />
    		</p:with-input>
    	</p:xslt>
    	
    	<tcy:debug file-extension="txt.xml" />    
    	
    	<p:xslt>
    		<p:with-input port="stylesheet">
    			<p:document href="refine/embedded-markup/line.xsl" />
    		</p:with-input>
    	</p:xslt>
    	
    	<tcy:debug file-extension="txt.xml" />     
    	
    	<p:xslt>
    		<p:with-input port="stylesheet">
    			<p:document href="refine/provenance.xsl" />
    		</p:with-input>
    	</p:xslt>
    	
    	<tcy:debug file-extension="txt.xml" />      	
        
        <p:group name="result-provenance-metadata">
        	
        	<tcy:insert-prov-metadata name="prov-metadata">
        		<p:with-option name="generated-by-user" select="$generated-by-user" />
        		<p:with-option name="generated-by-pipeline" select="p:urify(resolve-uri(''))" />
        		<p:with-option name="pipeline-start-time" select="$pipeline-start-time" />
        		<p:with-option name="pipeline-end-time" select="current-dateTime()" />
        		<p:with-option name="source-uri" select="p:urify(document-uri(/))">
        			<p:pipe port="source" step="gedcom-txt-to-xml" />
        		</p:with-option>
        	</tcy:insert-prov-metadata>    	    	
        
        	<tcy:debug file-extension="txt.xml" />        	      
	        
        </p:group>
        
    	
    </p:group>
        

    <p:group name="validate-gedcom-xml">       
        
        <tcy:validate-with-schematron name="validate-xml">
            <p:with-input port="source">
                <p:pipe port="result" step="gedcom-xml" />
            </p:with-input>
            <p:with-input port="schema" href="../../../../schemas/gedcom/unexpected.sch" />
        </tcy:validate-with-schematron>
                
        <p:choose>   
        	<p:with-input>
        		<p:pipe port="outcome" step="validate-xml" />        		
        	</p:with-input>  
            <p:when test=". = 'invalid'">       
            	
            	<p:store href="validation-errors.html">
            		<p:with-input port="source">
            			<p:pipe port="report-html" step="validate-xml" />
            		</p:with-input>
            	</p:store>            	
            	
            	<p:identity message="See validation-errors.html for report." />
            	
            	<p:sink />
            	
                <p:error code="invalid-document">
                	<p:with-input port="source">
                		<p:pipe port="report-xml" step="validate-xml" />
                	</p:with-input>
                </p:error>              	
            	
            </p:when>
            <p:otherwise>                
            	<p:identity>
            		<p:with-input port="source">
            			<p:pipe port="result" step="validate-xml" />
            		</p:with-input>
            	</p:identity>
            </p:otherwise>            
        </p:choose>    

    </p:group>
    
	
</p:declare-step>
<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="file:///home/sheila/Tools/xproc-schemas/xproc30.rnc" type="application/relax-ng-compact-syntax"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    xmlns:void="http://rdfs.org/ns/void#"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    name="dna-match-list-txt-to-xml"
    type="tcy:dna-match-list-txt-to-xml"
    version="3.0">
    
    <p:import href="../../../utils/text-to-xml/text2xml.xpl" />
	<p:import href="../../../utils/provenance/insert-prov-metadata.xpl" />
	<p:import href="../../../utils/debug.xpl" />
	<p:import href="../../../../../cenizaro/tools/schematron/validate-with-schematron.xpl" />
	<p:import href="../../../utils/store.xpl" />
    
    <p:input port="source" primary="true" content-types="text/xml">
    	<p:document href="../../../../../fortunes-olive-data/import/dna-analysis/data/2024-07-02_mum_6-400cm.xhtml" content-type="text/xml" />
    </p:input>
    <p:output port="result" sequence="true"/>
	
	<p:option name="path-to-error-log-folder" select="'../../data/debug/'" required="false" />  
	<p:option name="generated-by-user" required="false" />    
    <p:option name="debug" select="'true'" />
	
	<p:variable name="pipeline-start-time" select="current-dateTime()" />
        
	
	<p:xslt>
		<p:with-input port="source">
			<p:pipe port="source" step="dna-match-list-txt-to-xml" />
		</p:with-input>    
		<p:with-input port="stylesheet">
			<p:document href="create/parse_ancestry_xhtml.xsl" />
		</p:with-input>
	</p:xslt>
    
    <tcy:debug file-extension="xml" />

    <p:xslt>
    	<p:with-input port="stylesheet">
    		<p:document href="create/record.xsl" />
    	</p:with-input>
    </p:xslt>                                                 
    
	<tcy:debug file-extension="xml" />
    
    <p:xslt>
        <p:with-input port="stylesheet">
            <p:document href="refine/record.xsl" />
        </p:with-input>
    </p:xslt>    
    
	<tcy:debug file-extension="xml" />    
    
    <p:group name="result-provenance-metadata">
        
        <tcy:insert-prov-metadata name="prov-metadata">
        	<p:with-option name="generated-by-user" select="$generated-by-user" />
        	<p:with-option name="generated-by-pipeline" select="p:urify(resolve-uri(''))" />
        	<p:with-option name="pipeline-start-time" select="$pipeline-start-time" />
        	<p:with-option name="pipeline-end-time" select="current-dateTime()" />
        	<p:with-option name="source-uri" select="p:urify(document-uri(/))">
        		<p:pipe port="source" step="dna-match-list-txt-to-xml" />
        	</p:with-option>
        </tcy:insert-prov-metadata>    	    	
    
    	<tcy:debug file-extension="xml" />       	      
        
    </p:group>
	
</p:declare-step>
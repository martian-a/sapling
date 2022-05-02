<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="file:///home/sheila/Tools/xproc-schemas/xproc30.rnc" type="application/relax-ng-compact-syntax"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:prov="http://www.w3.org/ns/prov#"
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="add-id-to-extracts"
    type="tcy:add-id-to-extracts"
    version="3.0">

    
	<p:input port="source" primary="true" />
    <p:output port="result" sequence="false"/>    
    
    <p:choose>
    	<p:when test="//body-matter/extract[normalize-space(@id) = ''][normalize-space(string(body)) != '']">
    		    		    		
    		<p:add-attribute match="//body-matter/extract[normalize-space(@id) = '']" attribute-name="id" attribute-value="" />         	
    		<p:hash algorithm="md" match="//body-matter/extract[normalize-space(@id) = ''][not(preceding::body-matter/extract/normalize-space(@id) = '')]/@id">
    			<p:with-option name="value" select="serialize(
    				string(//body-matter/extract[normalize-space(@id) = ''][not(preceding::body-matter/extract/normalize-space(@id) = '')]/body)
    			)" />    			
    		</p:hash>
	    		    		
    		<tcy:add-id-to-extracts />
    		    		    		
        </p:when>
        <p:otherwise>
            <p:identity />
        </p:otherwise>
    </p:choose>
       
</p:declare-step>
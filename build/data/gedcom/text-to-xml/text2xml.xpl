<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="gedcom-txt-to-xml"
    type="tcy:gedcom-txt-to-xml"
    version="3.0">
    
    <p:import href="debug.xpl" />
    <p:import href="../../../../../cenizaro/tools/schematron/validate-with-schematron.xpl" />
    
    <p:input port="source" primary="true" />
    <p:output port="result" sequence="true" />
    
    <p:option name="debug" select="'true'" />
 
    <p:group name="gedcom-xml">       
        
        <p:output port="result" />
        
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/file.xsl" />
            </p:with-input>
        </p:xslt>     
        
        <tcy:debug  />
        
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/record.xsl" />
            </p:with-input>
        </p:xslt>
                
        <tcy:debug  />                
        
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/label.xsl" />
            </p:with-input>
        </p:xslt>    
        
        <tcy:debug  />      
        
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/unlabelled.xsl" />
            </p:with-input>
        </p:xslt>    
        
        <tcy:debug  />    
             
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/group.xsl" />
            </p:with-input>
        </p:xslt>    
        
        <tcy:debug  />        
                
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="create/supergroup.xsl" />
            </p:with-input>
        </p:xslt>   
        
        <tcy:debug  />
                
        <p:xslt>
            <p:with-input port="stylesheet">
                <p:document href="refine/refine-ged-xml.xsl" />
            </p:with-input>
        </p:xslt>
        
        <tcy:debug  />
        
    </p:group>
    

    <p:group name="validate-gedcom-xml">       
        
        <tcy:validate-with-schematron name="validate-xml">
            <p:with-input port="source">
                <p:pipe port="result" step="gedcom-xml" />
            </p:with-input>
            <p:with-input port="schema" href="../../../../schemas/gedcom/unexpected.sch" />
        </tcy:validate-with-schematron>
                
        <p:choose>
            <p:when test="/c:message">
                <p:error code="invalid-document">
                    <p:with-input port="source">
                        <p:pipe port="result" step="validate-xml" />
                    </p:with-input>
                </p:error>
            </p:when>
            <p:otherwise>                
                <p:identity message="Schematron validation successful ({*/@schema})." />
            </p:otherwise>            
        </p:choose>    

    </p:group>
       
</p:declare-step>
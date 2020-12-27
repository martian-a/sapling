<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="gedcom-txt-to-rdf"
    type="tcy:gedcom-txt-to-rdf"
    version="3.0">
    
    <p:import href="text-to-xml/text2xml.xpl" />
    <p:import href="../../../../cenizaro/tools/schematron/validate-with-schematron.xpl" />
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="true" />
    
    <p:option name="debug" select="'true'" />
 
 
    <tcy:gedcom-txt-to-xml name="gedcom-xml" />  
      
    <p:xslt name="sapling">
        <p:with-input port="source">
            <p:pipe port="result" step="gedcom-xml" />
        </p:with-input>
        <p:with-input port="stylesheet">
            <p:document href="xml-to-sapling/xml2sapling.xsl" />
        </p:with-input>
    </p:xslt>
        
    <p:choose>
        <p:when test="$debug = 'true'">    
            <p:store href="debug/{string-join((tokenize(data/@filename, '\.')[position() != last()], 'sapling.xml'), '.')}"
                serialization="map{'method' : 'xml', 'encoding' : 'utf-8', 'indent' : 'true'}" />
        </p:when>
    </p:choose>
   
    <p:group name="validate-sapling-xml">
        
        <tcy:validate-with-schematron name="validate-sapling">
            <p:with-input port="source">
                <p:pipe port="result" step="sapling" />
            </p:with-input>
            <p:with-input port="schema">
                <p:document href="../../../schemas/sapling/sapling.sch" />
            </p:with-input>
        </tcy:validate-with-schematron>
        
        
        <p:choose>
            <p:when test="/c:message">
                <p:error code="invalid-document">
                    <p:with-input port="source">
                        <p:pipe port="result" step="validate-sapling" />
                    </p:with-input>
                </p:error>
            </p:when>
            <p:otherwise>
                <p:identity message="Schematron validation successful ({*/@schema})." />
            </p:otherwise>
        </p:choose>        
        
    </p:group>
    
    
    <p:xslt>
        <p:with-input port="source">
            <p:pipe port="result" step="sapling" />
        </p:with-input>
        <p:with-input port="stylesheet">
            <p:document href="sapling-to-rdf/sapling2rdf.xsl" />
        </p:with-input>
        <p:with-option name="parameters" select="map{'resource-base-uri' : concat('http://ns.thecodeyard.co.uk/data/sapling/', tokenize(file/@filename, '\.')[1], '/')}">
            <p:pipe port="result" step="gedcom-xml" />
        </p:with-option>
    </p:xslt>    
    

    <p:xslt name="rdf">
        <p:with-input port="stylesheet">
            <p:document href="sapling-to-rdf/merge.xsl" />
        </p:with-input>
    </p:xslt>   

       
</p:declare-step>
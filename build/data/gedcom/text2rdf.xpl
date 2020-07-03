<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
    xmlns:c="http://www.w3.org/ns/xproc-step" 
    xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
    name="gedcom-txt-to-rdf"
    type="tcy:gedcom-txt-to-rdf"
    version="3.0">
    
    <p:input port="source" primary="true" />    
    <p:output port="result" sequence="true" />
    
    <p:import href="../../../../cenizaro/tools/schematron/validate-with-schematron.xpl" />
    
    <p:group name="gedcom-xml">       
        
        <p:output port="result" />
        
        <p:xslt>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:c="http://www.w3.org/ns/xproc-step"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        exclude-result-prefixes="#all"
                        version="2.0">                   
                        
                        <xsl:template match="/c:data">
                            <file href="{document-uri(/)}" filename="{tokenize(translate(document-uri(/), '\', '/'), '/')[last()]}">
                                <xsl:copy-of select="@*" />
                                <xsl:for-each select="tokenize(text(), '&#xD;\n')">
                                    <line><xsl:copy-of select="." /></line>
                                </xsl:for-each>
                            </file>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
            <p:input port="parameters">
                <p:empty />
            </p:input>
        </p:xslt>
        
        <p:xslt>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:c="http://www.w3.org/ns/xproc-step"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        exclude-result-prefixes="#all"
                        version="2.0">                   
                        
                        <xsl:template match="/file">
                            <file>
                                <xsl:copy-of select="@*" />
                                <xsl:for-each-group select="line" group-starting-with="self::*[starts-with(., '0 ')]" >
                                    <record>
                                        <xsl:copy-of select="current-group()" />
                                    </record>
                                </xsl:for-each-group>
                            </file>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
            <p:input port="parameters">
                <p:empty />
            </p:input>
        </p:xslt>
        
        <p:xslt>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:c="http://www.w3.org/ns/xproc-step"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        exclude-result-prefixes="#all"
                        version="2.0">                   
                        
                        <xsl:template match="/file">
                            <xsl:copy>
                                <xsl:copy-of select="@*" />
                                <xsl:for-each select="record">
                                    <xsl:variable name="type" select="line[1]/tokenize(normalize-space(.), ' ')[last()]" as="xs:string" />
                                    <xsl:variable name="id" select="line[1]/tokenize(normalize-space(.), ' ')[starts-with(., '@') and ends-with(., '@')]" as="xs:string?" />
                                    <xsl:copy>
                                        <xsl:copy-of select="@*" />
                                        <xsl:attribute name="type" select="$type" />
                                        <xsl:if test="$id">
                                            <xsl:attribute name="id" select="$id" />
                                        </xsl:if>                       
                                        <xsl:apply-templates select="line[position() &gt; 1][text()]" />                       
                                    </xsl:copy>
                                </xsl:for-each>
                            </xsl:copy>
                        </xsl:template>
                        
                        <xsl:template match="record/line">
                            <xsl:variable name="level" select="tokenize(., ' ')[1]" as="xs:string" />
                            <xsl:variable name="label" select="tokenize(., ' ')[2]" as="xs:string" />
                            <line level="{$level}" label="{$label}"><xsl:value-of select="tokenize(., ' ')[position() &gt; 2]" /></line>
                        </xsl:template>
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
            <p:input port="parameters">
                <p:empty />
            </p:input>
        </p:xslt>    
        
        
        <p:xslt>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:c="http://www.w3.org/ns/xproc-step"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        exclude-result-prefixes="#all"
                        version="2.0">                   
                        
                        <xsl:template match="/file">
                            <xsl:copy>
                                <xsl:copy-of select="@*" />
                                <xsl:apply-templates select="record[line]" />
                            </xsl:copy>
                        </xsl:template>
                        
                        <xsl:template match="file/record">
                            <xsl:copy>
                                <xsl:copy-of select="@*" />
                                <xsl:for-each-group select="line" group-starting-with="self::*[not(@level = preceding-sibling::*[1]/@level)]">
                                    <group level="{current-group()[1]/@level}">
                                        <xsl:copy-of select="current-group()" />
                                    </group>
                                </xsl:for-each-group>
                            </xsl:copy>
                        </xsl:template>  
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
            <p:input port="parameters">
                <p:empty />
            </p:input>
        </p:xslt>    
        
        
        <p:xslt>
            <p:input port="stylesheet">
                <p:inline>
                    <xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                        xmlns:c="http://www.w3.org/ns/xproc-step"
                        xmlns:fn="http://ns.thecodeyard.co.uk/functions"
                        xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        exclude-result-prefixes="#all"
                        version="2.0">                   
                        
                        <xsl:template match="/file">
                            <xsl:copy>
                                <xsl:copy-of select="@*" />
                                <xsl:apply-templates select="record[group]" />
                            </xsl:copy>
                        </xsl:template>
                        
                        <xsl:template match="file/record">
                            <xsl:element name="{@type}">
                                <xsl:copy-of select="@*[local-name() != 'type']" />
                                <xsl:sequence select="fn:group(group)" />
                            </xsl:element>
                        </xsl:template>    
                        
                        <xsl:function name="fn:group" as="element()*">
                            <xsl:param name="super-group" as="element()*" />
                            
                            <xsl:for-each-group select="$super-group" group-starting-with="self::*[@level = $super-group[1]/@level]">
                                <xsl:variable name="current-level" select="current-group()[1]/@level" as="xs:integer" />
                                <xsl:for-each select="current-group()/line[@level = $current-level]">
                                    <xsl:variable name="descendants" select="current-group()[not(line[@level = $current-level])]" as="element()*" />
                                    <xsl:element name="{@label}">
                                        <xsl:choose>
                                            <xsl:when test="position() = last() and $descendants">
                                                <value><xsl:apply-templates /></value>
                                            </xsl:when>
                                            <xsl:otherwise><xsl:apply-templates /></xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:if test="position() = last() and $descendants">
                                            <xsl:sequence select="fn:group($descendants)" />                        
                                        </xsl:if>                    
                                    </xsl:element>   
                                </xsl:for-each>
                            </xsl:for-each-group>
                            
                        </xsl:function>
                        
                        
                        <xsl:template match="document-node() | * | comment() | processing-instruction()">
                            <xsl:copy>
                                <xsl:copy-of select="@*" />
                                <xsl:apply-templates />
                            </xsl:copy>
                        </xsl:template> 
                        
                    </xsl:stylesheet>
                </p:inline>
            </p:input>
            <p:input port="parameters">
                <p:empty />
            </p:input>
        </p:xslt>   
        
        <p:xslt>
            <p:input port="stylesheet">
                <p:document href="text-to-xml/text2xml.xsl" />
            </p:input>
            <p:input port="parameters">
                <p:empty />
            </p:input>
        </p:xslt>
    
    </p:group>
        
    <p:store method="xml" encoding="utf-8" indent="true">
        <p:with-option name="href" select="string-join((tokenize(file/@filename, '\.')[position() != last()], 'xml'), '.')" />
    </p:store>
    
    <p:group name="validate-gedcom-xml">       
        
        <tcy:validate-with-schematron name="validate-xml">
            <p:input port="source">
                <p:pipe port="result" step="gedcom-xml" />
            </p:input>
            <p:input port="stylesheet">
                <p:document href="../../../schemas/gedcom/unexpected.sch" />
            </p:input>
        </tcy:validate-with-schematron>
        
        <p:choose>
            <p:when test="/c:message">
                <p:error code="invalid-document">
                    <p:input port="source">
                        <p:pipe port="result" step="validate-xml" />
                    </p:input>
                </p:error>
            </p:when>
            <p:otherwise>
                <p:identity>
                    <p:input port="source">
                        <p:inline><c:message>Validation successful.</c:message></p:inline>
                    </p:input>
                </p:identity>
            </p:otherwise>
        </p:choose>
    
        <p:sink />

    </p:group>
    
  
    <p:xslt name="sapling">
        <p:input port="source">
            <p:pipe port="result" step="gedcom-xml" />
        </p:input>
        <p:input port="stylesheet">
            <p:document href="xml-to-sapling/xml2sapling.xsl" />
        </p:input>
        <p:input port="parameters">
            <p:empty />
        </p:input>
    </p:xslt>
        
    <p:store method="xml" encoding="utf-8" media-type="text/xml" indent="true">
        <p:with-option name="href" select="string-join((tokenize(data/@filename, '\.')[position() != last()], 'sapling.xml'), '.')" />
    </p:store>
   

    <p:group name="validate-sapling-xml">
        
        <tcy:validate-with-schematron name="validate-sapling">
            <p:input port="source">
                <p:pipe port="result" step="sapling" />
            </p:input>
            <p:input port="stylesheet">
                <p:document href="../../../schemas/sapling/sapling.sch" />
            </p:input>
        </tcy:validate-with-schematron>
        
        <p:choose>
            <p:when test="/c:message">
                <p:error code="invalid-document">
                    <p:input port="source">
                        <p:pipe port="result" step="validate-sapling" />
                    </p:input>
                </p:error>
            </p:when>
            <p:otherwise>
                <p:identity>
                    <p:input port="source">
                        <p:inline><c:message>Schematron validation successful.</c:message></p:inline>
                    </p:input>
                </p:identity>
            </p:otherwise>
        </p:choose>
        
        <!--
        <p:validate-with-relax-ng assert-valid="true">
            <p:input port="schema">
                <p:document href="../../../schemas/sapling/sapling.rnc" />
            </p:input>
            <p:input port="parameters">
                <p:empty />
            </p:input>
        </p:validate-with-relax-ng>
        -->
        
        <p:sink />     
        
    </p:group>
    
    
    <p:xslt name="rdf">
        <p:input port="source">
            <p:pipe port="result" step="sapling" />
        </p:input>
        <p:input port="stylesheet">
            <p:document href="sapling-to-rdf/sapling2rdf.xsl" />
        </p:input>
        <p:with-param name="resource-base-uri" select="concat('http://ns.thecodeyard.co.uk/data/sapling/', tokenize(file/@filename, '\.')[1], '/')">
            <p:pipe port="result" step="gedcom-xml" />
        </p:with-param>
    </p:xslt>    
    
    <p:store method="xml" encoding="utf-8" media-type="application/rdf+xml" indent="true">
        <p:with-option name="href" select="string-join((tokenize(file/@filename, '\.')[position() != last()], 'rdf.xml'), '.')">
            <p:pipe port="result" step="gedcom-xml" />
        </p:with-option>
    </p:store>
    

    <p:identity>
        <p:input port="source">
            <p:pipe port="result" step="rdf" />
        </p:input>
    </p:identity>

    
</p:declare-step>
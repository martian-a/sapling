<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:c="http://www.w3.org/ns/xproc-step"
    xmlns:fn="http://ns.thecodeyard.co.uk/functions"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="#all"
    version="2.0">
    
    <xsl:output indent="yes" />
    
    <xsl:variable name="dictionaries" as="document-node()">
        <xsl:document>
            <dictionaries>
                <dictionary scheme="gedcom" version="5.5">
                    <entry abbreviation="ADDR" expanded="address" />
                    <entry abbreviation="ADOP" expanded="adoption" />
                    <entry abbreviation="AFN" expanded="ancestral-file-number" />
                    <entry abbreviation="ALIA" expanded="alias" />
                    <entry abbreviation="AUTH" expanded="author" />
                    <entry abbreviation="BAPM" expanded="baptism" />
                    <entry abbreviation="BIRT" expanded="birth" />
                    <entry abbreviation="BURI" expanded="burial" />
                    <entry abbreviation="CHAR" expanded="character-set" />
                    <entry abbreviation="CHIL" expanded="child" />
                    <entry abbreviation="CORP" expanded="name-of-business" />
                    <entry abbreviation="COPR" expanded="copyright" />                
                    <entry abbreviation="DATA" expanded="name-of-source-data" />
                    <entry abbreviation="DATE" expanded="date" />
                    <entry abbreviation="DEAT" expanded="death" />
                    <entry abbreviation="DEST" expanded="receiving-system-name" />
                    <entry abbreviation="DIV" expanded="divorce" />
                    <entry abbreviation="EDUC" expanded="education" />
                    <entry abbreviation="EMIG" expanded="emigration" />
                    <entry abbreviation="ENGA" expanded="engagement" />
                    <entry abbreviation="EVEN" expanded="event" />
                    <entry abbreviation="FAM" expanded="family" /> 
                    <entry abbreviation="FAMC" expanded="family-child" /> 
                    <entry abbreviation="FAMS" expanded="family-spouse" />                
                    <entry abbreviation="FILE" expanded="file-name" />
                    <entry abbreviation="FORM" expanded="form" />
                    <entry abbreviation="GEDC" expanded="gedcom" />
                    <entry abbreviation="GIVN" expanded="given" />
                    <entry abbreviation="HUSB" expanded="husband" />
                    <entry abbreviation="IMMI" expanded="immigration" />
                    <entry abbreviation="LANG" expanded="language-of-text" />
                    <entry abbreviation="MARR" expanded="marriage" />
                    <entry abbreviation="NAME" expanded="name" />
                    <entry abbreviation="NPFX" expanded="prefix" />
                    <entry abbreviation="NICK" expanded="nickname" />
                    <entry abbreviation="NOTE" expanded="note" />
                    <entry abbreviation="NSFX" expanded="suffix" />
                    <entry abbreviation="OBJE" expanded="object" />
                    <entry abbreviation="OCCU" expanded="occupation" />
                    <entry abbreviation="ORDN" expanded="ordination" />
                    <entry abbreviation="PAGE" expanded="page" />
                    <entry abbreviation="PHON" expanded="phone-number" />
                    <entry abbreviation="PLAC" expanded="place" />
                    <entry abbreviation="PROB" expanded="probate" />      
                    <entry abbreviation="PROP" expanded="property" />
                    <entry abbreviation="PUBL" expanded="publication" />
                    <entry abbreviation="RELI" expanded="religion" />
                    <entry abbreviation="RESI" expanded="residence" />
                    <entry abbreviation="RESN" expanded="restriction-notice" />
                    <entry abbreviation="REFN" expanded="user-reference-number" />
                    <entry abbreviation="REPO" expanded="repository" />
                    <entry abbreviation="RFN" expanded="permanent-record-file-number" />
                    <entry abbreviation="RIN" expanded="automated-record-id" />
                    <entry abbreviation="ROLE" expanded="role" />
                    <entry abbreviation="SEX" expanded="sex" />
                    <entry abbreviation="SPFX" expanded="surname-prefix" />
                    <entry abbreviation="STAT" expanded="status" />
                    <entry abbreviation="SURN" expanded="surname" />
                    <entry abbreviation="TEXT" expanded="text" />
                    <entry abbreviation="TIME" expanded="time-value" />
                    <entry abbreviation="TITL" expanded="title" />
                    <entry abbreviation="TYPE" expanded="type" />
                    <entry abbreviation="VERS" expanded="version-number" />
                    <entry abbreviation="WIFE" expanded="wife" />
                    <entry abbreviation="WILL" expanded="will" />
                </dictionary>
                <dictionary scheme="Ancestry.com Family Trees" version="2010.3">
                    <entry abbreviation="_DEG" expanded="degree" />
                    <entry abbreviation="_ELEC" expanded="elected" />
                    <entry abbreviation="_EMPLOY" expanded="employment" />
                    <entry abbreviation="_FREL" expanded="f-relationship" />
                    <entry abbreviation="_FUN" expanded="funeral" />                      
                    <entry abbreviation="_INIT" expanded="initiation" />
                    <entry abbreviation="_MREL" expanded="m-relationship" />
                    <entry abbreviation="_MILT" expanded="military" />
                    <entry abbreviation="_MILTID" expanded="military-serial-number" />
                    <entry abbreviation="_MISN" expanded="miscellaneous" />
                    <entry abbreviation="_SEPR" expanded="separation" /> 
                </dictionary>
            </dictionaries>
        </xsl:document>
    </xsl:variable>


    <xsl:include href="head.xsl" />
    <xsl:include href="individual.xsl" />  
    <xsl:include href="family.xsl" />  
    <xsl:include href="source.xsl" />
    <xsl:include href="repeated-sub-structures.xsl" />
    <xsl:include href="place.xsl" /> 


    <xsl:template match="/">
        <xsl:document>
            <xsl:processing-instruction name="xml-model">href="http://ns.thecodeyard.co.uk/schema/sapling/gedcom/unexpected.sch?v=1.0.0" type="application/xml" schematypens="http://purl.oclc.org/dsdl/schematron"</xsl:processing-instruction>            
            <xsl:apply-templates />
        </xsl:document>
    </xsl:template>    
    
        
    <xsl:template match="*" mode="#all" priority="1">
        <xsl:next-match>
            <xsl:with-param name="expanded" select="$dictionaries/*/*/entry[@abbreviation = current()/local-name()]/@expanded" as="xs:string?" />
        </xsl:next-match>        
    </xsl:template>
        
    <xsl:template match="* | comment() | processing-instruction()" mode="#all">
        <xsl:param name="expanded" as="xs:string?" />
        <xsl:element name="{if ($expanded) then $expanded else local-name()}">
            <xsl:copy-of select="@*" />
            <xsl:apply-templates mode="#current"/>
        </xsl:element>
    </xsl:template> 
    
</xsl:stylesheet>
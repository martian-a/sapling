<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:kai="http://ns.kaikoda.com/xslt/functions"
    exclude-result-prefixes="xs kai"
    version="2.0">
    
    <xsl:import href="functions/functions.xsl" />
	<xsl:import href="people/person.xsl" />
	<xsl:import href="events/event.xsl" />
    
    <xsl:output name="xhtml"
        method="xml" 
        indent="yes"
        omit-xml-declaration="yes"        
    />
    
</xsl:stylesheet>

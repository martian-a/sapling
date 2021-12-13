<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:pattern>
        
    	<sch:rule context="*[not(namespace-uri()=('http://www.w3.org/ns/prov#', 'http://rdfs.org/ns/void#', 'http://xmlns.com/foaf/0.1/'))]">
            <sch:let name="unexpected-characters" value="translate(name(), 'abcdefghijklmnopqrstuvwxyz-', '')" />
            
    		<sch:assert test="self::*[string-length($unexpected-characters) = 0]">Element local-name contains <sch:value-of select="string-length($unexpected-characters)" /> unexpected characters: <sch:value-of select="$unexpected-characters" /></sch:assert>
            
        </sch:rule>
    </sch:pattern>
    
</sch:schema>
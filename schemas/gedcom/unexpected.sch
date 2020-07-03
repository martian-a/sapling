<sch:schema xmlns:sch="http://purl.oclc.org/dsdl/schematron" queryBinding="xslt2"
    xmlns:sqf="http://www.schematron-quickfix.com/validator/process">
    
    <sch:pattern>
        
        <sch:rule context="*">
            <sch:let name="unexpected-characters" value="translate(name(), 'abcdefghijklmnopqrstuvwxyz-', '')" />
            
            <sch:assert test="self::*[string-length($unexpected-characters) = 0]">Element local-name contains <sch:value-of select="string-length($unexpected-characters)" /> unexpected characters: <sch:value-of select="$unexpected-characters" /></sch:assert>
            
        </sch:rule>
    </sch:pattern>
    
</sch:schema>
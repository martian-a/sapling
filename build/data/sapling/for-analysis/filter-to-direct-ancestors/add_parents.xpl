<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	name="add-parents"
	type="tcy:add-parents"
	version="3.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Add back in currently excluded people that are parents of included people.</d:p>
		</d:desc>
	</p:documentation>
	
	<p:input port="source" primary="true" />
	
	<p:output port="result" sequence="false" />		
	
	<p:variable select="/data/exclude/events/concat('(', codepoints-to-string(39), replace(string-join(event[person/@ref = /data/include/people/person/@id]/parent/@ref, ','), ',', concat(codepoints-to-string(39), ',', codepoints-to-string(39))), codepoints-to-string(39), ')')" name="parent-refs" as="xs:string?" />

	<p:filter select="/data/exclude/people/person[@id = {$parent-refs}]" name="parent-entities" />
	
	<p:wrap-sequence wrapper="include" />	
			
	<p:choose>
		
		<p:when test="/include/*">
			
			<p:sink />
			
			<p:insert match="/data/include/people" position="last-child">
				<p:with-input port="insertion" select="/*">
					<p:pipe port="result" step="parent-entities" />
				</p:with-input>
				<p:with-input port="source">
					<p:pipe port="source" step="add-parents" />
				</p:with-input>
			</p:insert>
			
			<p:delete match="/data/exclude/people/person[@id = /data/include/people/person/@id]" />			
			
			<tcy:add-parents />
			
		</p:when>
		
		<p:otherwise>
			
			<p:sink />					
			
			<p:identity>
				<p:with-input port="source">
					<p:pipe port="source" step="add-parents" />
				</p:with-input>
			</p:identity>
			
		</p:otherwise>
		
	</p:choose>
		
</p:declare-step>
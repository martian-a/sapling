<?xml version="1.0" encoding="UTF-8"?>
<?xml-model href="file:///home/sheila/Tools/xproc-schemas/xproc30.rnc" type="application/relax-ng-compact-syntax"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:c="http://www.w3.org/ns/xproc-step" 
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:prov="http://www.w3.org/ns/prov#"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"	
	xmlns:xs = "http://www.w3.org/2001/XMLSchema"
	version="3.0"
	name="uuid"
	type="tcy:uuid">
	
	<p:input port="source" primary="true" />
	<p:output port="result" sequence="false" />
	
	<p:option name="replace-values" required="true" as="xs:string*"  />
		
	<p:documentation>
		<d:doc scope="pipeline">
			<d:desc>
				<d:p>Replaces @id values, prefixed with 'REPLACE-', with a version 4 UUID.</d:p>
			</d:desc>
		</d:doc>
	</p:documentation>
	
	<p:variable name="current-value" select="$replace-values[1]" as="xs:string?" /> 			
					
	<p:choose>
		
		<p:when test="$current-value">
			
			<p:uuid match="descendant-or-self::*/@*[. = '{$current-value}']" version="4" />
			
			<tcy:uuid>
				<p:with-option name="replace-values" select="$replace-values[position() > 1]" />
			</tcy:uuid>
			
		</p:when>
		<p:otherwise>
			<p:identity />
		</p:otherwise>
	</p:choose>				
			
	
</p:declare-step>
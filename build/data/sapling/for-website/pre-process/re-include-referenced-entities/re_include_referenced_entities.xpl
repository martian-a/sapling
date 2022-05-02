<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step
	xmlns:c="http://www.w3.org/ns/xproc-step"
	xmlns:cxf="http://xmlcalabash.com/ns/extensions/fileutils"
	xmlns:d="http://ns.kaikoda.com/documentation/xml"
	xmlns:p="http://www.w3.org/ns/xproc"
	xmlns:tcy="http://ns.thecodeyard.co.uk/xproc/step"
	name="re-include-referenced-entities"
	type="tcy:re-include-referenced-entities"
	version="3.0">
	
	
	<p:documentation>
		<d:desc>
			<d:p>Add back in currently excluded entities that are referenced by core entities.</d:p>
		</d:desc>
	</p:documentation>
	
	<p:input port="source" primary="true" />
	
	<p:output port="result" sequence="true" />		
	
	<p:xslt name="referenced-entities">
		<p:with-input port="stylesheet">
			<p:document href="list_cross_references.xsl" />
		</p:with-input>
	</p:xslt>

	
	<p:choose>
		
		<p:when test="/cross-references/*">
			
			<p:identity message="Cross-references found" />
			
			<p:sink />
			
			<p:insert 
				match="/data/include"
				position="last-child">
				<p:with-input port="source">
					<p:pipe port="source" step="re-include-referenced-entities"/>
				</p:with-input>
				<p:with-input port="insertion" select="/cross-references/*">
					<p:pipe port="result" step="referenced-entities" />
				</p:with-input>
			</p:insert>			
						
			<p:delete match="/data/exclude/*/*[@id = /data/include/*/*/@id]" />	
			
			<tcy:re-include-referenced-entities />
			
		</p:when>
		
		<p:otherwise>
			
			<p:identity message="Cross-references not found" />
			
			<p:sink />
			
			<p:xslt>
				<p:with-input port="source">
					<p:pipe port="source" step="re-include-referenced-entities" />
				</p:with-input>
				<p:with-input port="stylesheet">
					<p:document href="clean_up.xsl" />
				</p:with-input>
			</p:xslt>	
			
		</p:otherwise>
	</p:choose>	
	
	
</p:declare-step>
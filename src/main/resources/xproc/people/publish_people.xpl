<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:k="http://schema.kaikoda.com/ns/xproc" name="publish-people" type="k:publish-people" version="1.0">
				
	<p:option name="root-publication-directory" required="true" />
	
	<p:output port="result" sequence="false" primary="true">
		<p:pipe step="links-to-published-files" port="result" />
	</p:output>
	
	<p:import href="../library.xpl"/>


	<k:get-people-data name="get-people-data" />

	
	<k:show-people name="show-people">
		
		<p:input port="source">
			<p:pipe step="get-people-data" port="result" />
		</p:input>
		
		<p:with-option name="root-publication-directory" select="$root-publication-directory" />
		
	</k:show-people>	
	
	<p:sink />
	
	<p:for-each name="publish-person">
		
		<p:iteration-source select="/sapling/people/person">			
			<p:pipe step="get-people-data" port="result" />
		</p:iteration-source>					
		
		<p:output port="result" sequence="true" primary="true">
			<p:pipe step="show-person" port="result" />
		</p:output>	
		
		<k:get-person-data name="get-person-data">
			<p:with-option name="id" select="person/@id" />			
		</k:get-person-data>		

		<k:show-person name="show-person">
			
			<p:input port="source">
				<p:pipe step="get-person-data" port="result" />
			</p:input>											
			
			<p:with-option name="root-publication-directory" select="$root-publication-directory" />			

		</k:show-person>
		
	</p:for-each>
	
	<p:sink />
	
	<p:wrap-sequence wrapper="sapling" name="links-to-published-files">
		
		<p:input port="source" select="/sapling/link">
			<p:pipe step="show-people" port="result" />
			<p:pipe step="publish-person" port="result" />
		</p:input>					
		
	</p:wrap-sequence>
	
</p:declare-step>